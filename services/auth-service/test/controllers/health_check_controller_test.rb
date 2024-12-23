require "test_helper"

class HealthCheckControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    # Test that the 'show' action returns the correct status when the server is up
    get health_check_url
    assert_response :ok
    assert_equal({ "status" => "Server is up" }, JSON.parse(response.body))
  end

  test "should get dependencies with all services up" do
    # Mock methods for health checks to return 'ok'
    checks = {
      database: { status: "ok" },
      cache: { status: "ok" }
    }

    # Mock database check to return ok
    HealthCheckController.any_instance.stubs(:check_database).returns({ status: "ok" })
    # Mock cache check to return ok
    Rails.cache.stubs(:fetch).returns("ok")

    # Make a request to the 'dependencies' action
    get ready_check_url
    assert_response :ok
    # Verify the correct response is returned
    assert_equal({ "status" => "ok", "checks" => checks }.to_json, response.body)
  end

  test "should get dependencies with database failure" do
    # Mock that the database is down and cache is up
    checks = {
      database: { status: "fail", message: "Database error" },
      cache: { status: "ok" }
    }

    # Simulate database failure
    HealthCheckController.any_instance.stubs(:check_database).returns({ status: "fail", message: "Database error" })
    # Simulate cache being ok
    HealthCheckController.any_instance.stubs(:check_cache).returns({ status: "ok" })

    # Make a request to the 'dependencies' action
    get ready_check_url
    assert_response :service_unavailable
    # Verify the response includes the failure status for database
    assert_equal({ "status" => "fail", "checks" => checks }.to_json, response.body)
  end

  test "should get dependencies with cache failure" do
    # Mock that the cache is down and database is up
    checks = {
      database: { status: "ok" },
      cache: { status: "fail", message: "Cache not responding" }
    }

    # Simulate database being ok
    HealthCheckController.any_instance.stubs(:check_database).returns({ status: "ok" })
    # Simulate cache failure
    HealthCheckController.any_instance.stubs(:check_cache).returns({ status: "fail", message: "Cache not responding" })

    # Make a request to the 'dependencies' action
    get ready_check_url
    assert_response :service_unavailable
    # Verify the response includes the failure status for cache
    assert_equal({ "status" => "fail", "checks" => checks }.to_json, response.body)
  end

  test "should get dependencies with both database and cache failures" do
    # Mock that both the database and cache are down
    checks = {
      database: { status: "fail", message: "Database error" },
      cache: { status: "fail", message: "Cache not responding" }
    }

    # Simulate both database and cache failures
    HealthCheckController.any_instance.stubs(:check_database).returns({ status: "fail", message: "Database error" })
    HealthCheckController.any_instance.stubs(:check_cache).returns({ status: "fail", message: "Cache not responding" })

    # Make a request to the 'dependencies' action
    get ready_check_url
    assert_response :service_unavailable
    # Verify the response includes the failure statuses for both database and cache
    assert_equal({ "status" => "fail", "checks" => checks }.to_json, response.body)
  end
end
