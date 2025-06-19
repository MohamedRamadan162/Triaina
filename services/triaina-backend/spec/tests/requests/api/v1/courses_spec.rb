require 'rails_helper'

RSpec.describe "Courses", type: :request do
  # Create user
  let(:user) {
    create(:user, admin: true)
  }

  describe "when authenticated" do
    # All operations are authenticated
    before do
      post "#{TestConstants::DEFAULT_API_BASE_URL}/auth/login", params: {
        email: user[:email],
        password: TestConstants::DEFAULT_USER[:password]
      }
    end

    describe "GET #{TestConstants::DEFAULT_API_BASE_URL}/courses" do
      it "returns all courses" do
        get "#{TestConstants::DEFAULT_API_BASE_URL}/courses"
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["success"]).to be true
        expect(json["courses"]).to eq(CourseSerializer.render(Course.all))
      end
    end

    describe "GET #{TestConstants::DEFAULT_API_BASE_URL}/courses/:id" do
      let(:course) { create(:course) }
      it "returns course" do
        get "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}"
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["success"]).to be true
        expect(json["course"]).to eq(JSON.parse(CourseSerializer.render(course).to_json))
      end
    end

    describe "POST #{TestConstants::DEFAULT_API_BASE_URL}/courses" do
      it "creates a new course" do
        post "#{TestConstants::DEFAULT_API_BASE_URL}/courses", params: {
            name: "New Course",
            description: "Course description",
            start_date: "2025-05-04T00:00:00.000Z",
            end_date: nil
        }
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["success"]).to be true
        expect(json["course"]).to eq(JSON.parse(CourseSerializer.render(Course.last).to_json))
      end
    end

    describe "PUT #{TestConstants::DEFAULT_API_BASE_URL}/courses/:id" do
      let(:course) { create(:course) }
      it "updates course using id" do
        put "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}", params: {
          name: "new name",
          description: "new des"
        }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["success"]).to be true
        expect(json["course"]["name"]).to eq("new name")
        expect(json["course"]["description"]).to eq("new des")
      end
    end

    describe "DELETE #{TestConstants::DEFAULT_API_BASE_URL}/courses/:id" do
      let(:course) { create(:course) }
      it "deletes course" do
        delete "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}"
        expect(response).to have_http_status(:no_content)
        expect(Course.exists?(course.id)).to be false
      end
    end
  end

  describe "when unauthorized" do
    describe "GET #{TestConstants::DEFAULT_API_BASE_URL}/courses" do
      it "returns unauthorized status" do
        get "#{TestConstants::DEFAULT_API_BASE_URL}/courses"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "GET #{TestConstants::DEFAULT_API_BASE_URL}/courses/:id" do
      let(:course) { create(:course) }
      it "returns unauthorized status" do
        get "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "POST #{TestConstants::DEFAULT_API_BASE_URL}/courses" do
      it "returns unauthorized status" do
        post "#{TestConstants::DEFAULT_API_BASE_URL}/courses", params: {
          name: "Unauthorized Course",
          description: "Should not create",
          start_date: "2025-06-01T00:00:00.000Z",
          end_date: nil
        }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "PUT #{TestConstants::DEFAULT_API_BASE_URL}/courses/:id" do
      let(:course) { create(:course) }
      it "returns unauthorized status" do
        put "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}", params: {
          name: "should fail",
          description: "unauthorized"
        }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "DELETE #{TestConstants::DEFAULT_API_BASE_URL}/courses/:id" do
      let(:course) { create(:course) }
      it "returns unauthorized status" do
        delete "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
