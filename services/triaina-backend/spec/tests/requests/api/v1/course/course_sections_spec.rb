require 'rails_helper'

RSpec.describe "Api::V1::Courses::CourseSectionsController", type: :request do
  describe "Course Sections Management" do
    let!(:user) { create(:user, admin: true) }
    let!(:section) { create(:course_section) }
    let!(:course) { section.course }

    before do
      post "#{TestConstants::DEFAULT_API_BASE_URL}/auth/login", params: { email: user.email, password: TestConstants::DEFAULT_USER[:password] }
    end

    describe "GET #{TestConstants::DEFAULT_API_BASE_URL}/courses/:course_id/sections" do
      context "when sections exist" do
        before do
          get "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/sections"
        end

        it "returns the list of sections" do
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json["success"]).to be true
          expect(json["sections"].length).to be > 0
          expect(json["sections"].first["id"]).to eq(section.id)
        end
      end

      context "when no sections exist" do
        before do
          CourseSection.destroy_all
          get "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/sections"
        end

        it "returns an empty list" do
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json["success"]).to be true
          expect(json["sections"]).to be_empty
        end
      end
    end

    describe "GET #{TestConstants::DEFAULT_API_BASE_URL}/courses/:course_id/sections/:section_id" do
      context "when section exists" do
        before do
          get "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/sections/#{section.id}"
        end

        it "returns the section details" do
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json["success"]).to be true
          expect(json["section"]["id"]).to eq(section.id)
          expect(json["section"]["title"]).to eq(section.title)
        end
      end

      context "when section does not exist" do
        before do
          get "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/sections/999999"
        end

        it "returns a not found error" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe "POST #{TestConstants::DEFAULT_API_BASE_URL}/courses/:course_id/sections" do
      context "with valid parameters" do
        before do
          post "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/sections",
            params: {
              title: "New Section",
              description: "Section Description"
            }
        end

        it "creates a new section" do
          expect(response).to have_http_status(:created)
          json = JSON.parse(response.body)
          expect(json["success"]).to be true
          expect(json["section"]["title"]).to eq("New Section")
          expect(json["section"]["description"]).to eq("Section Description")
        end
      end

      context "with invalid parameters" do
        before do
          post "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/sections",
            params: {
              title: ""
            }
        end

        it "returns an error" do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "PATCH #{TestConstants::DEFAULT_API_BASE_URL}/courses/:course_id/sections/:section_id" do
      context "when section exists" do
        before do
          patch "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/sections/#{section.id}", params: {
                  title: "Updated Title",
                  description: "Updated Description"
                }
        end

        it "updates the section" do
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json["success"]).to be true
          expect(json["section"]["title"]).to eq("Updated Title")
          expect(json["section"]["description"]).to eq("Updated Description")
        end
      end

      context "when section does not exist" do
        before do
          patch "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/sections/999999", params: {
                  title: "Updated Title",
                  description: "Updated Description"
                }
        end

        it "returns a not found error" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe "DELETE #{TestConstants::DEFAULT_API_BASE_URL}/courses/:course_id/sections/:section_id" do
      context "when section exists" do
        before do
          delete "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/sections/#{section.id}"
        end

        it "deletes the section" do
          expect(response).to have_http_status(:no_content)
          expect(CourseSection.find_by(id: section.id)).to be_nil
        end
      end

      context "when section does not exist" do
        before do
          delete "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/sections/999999"
        end

        it "returns a not found error" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
