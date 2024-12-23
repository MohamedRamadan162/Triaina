class HealthCheckController < ApplicationController
  def show
    render json: { status: "Server is up" }, status: :ok
  end

  def dependencies
    checks = {}

    # Database Check
    checks[:database] = check_database

    # Cache Check (e.g., Redis)
    checks[:cache] = check_cache

    # Determine overall status
    overall_status = checks.values.all? { |check| check[:status] == "ok" } ? "ok" : "fail"

    render json: { status: overall_status, checks: checks }, status: overall_status == "ok" ? :ok : :service_unavailable
  end

  private

  def check_database
    ActiveRecord::Base.connection.execute("SELECT 1")
    { status: "ok" }
  rescue => e
    { status: "fail", message: e.message }
  end

  def check_cache
    Rails.cache.fetch("health_check_status") { "ok" } ? { status: "ok" } : { status: "fail", message: "Cache not responding" }
  rescue => e
    { status: "fail", message: e.message }
  end
end
