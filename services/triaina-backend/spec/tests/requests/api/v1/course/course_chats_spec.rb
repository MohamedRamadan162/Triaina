require 'rails_helper'

RSpec.describe "Api::V1::Courses::CourseChatsController", type: :request do
  describe "Chat Channels Management" do
    let!(:user) { create(:user, admin: true) }
    let!(:course) { create(:course) }
    let!(:course_chat) { create(:course_chat, course: course) }

    before do
      post "#{TestConstants::DEFAULT_API_BASE_URL}/auth/login", params: { email: user.email, password: TestConstants::DEFAULT_USER[:password] }
    end

    describe "GET #{TestConstants::DEFAULT_API_BASE_URL}/courses/:course_id/course_chats" do
      context "when chat channels exist" do
        let!(:second_channel) { create(:course_chat, course: course) }

        before do
          get "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/course_chats"
        end

        it "returns the list of chat channels ordered by created_at" do
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json["success"]).to be true
          expect(json["course_chats"].length).to eq(2)
          expect(json["course_chats"].first["id"]).to eq(course_chat.id)
          expect(json["course_chats"].last["id"]).to eq(second_channel.id)
        end
      end

      context "when no chat channels exist" do
        before do
          CourseChat.destroy_all
          get "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/course_chats"
        end

        it "returns an empty list" do
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json["success"]).to be true
          expect(json["course_chats"]).to be_empty
        end
      end

      context "when course does not exist" do
        before do
          get "#{TestConstants::DEFAULT_API_BASE_URL}/courses/999999/course_chats"
        end

        it "returns a not found error" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe "GET #{TestConstants::DEFAULT_API_BASE_URL}/courses/:course_id/course_chats/:id" do
      context "when chat channel exists" do
        before do
          get "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/course_chats/#{course_chat.id}"
        end

        it "returns the chat channel details" do
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json["success"]).to be true
          expect(json["course_chat"]["id"]).to eq(course_chat.id)
          expect(json["course_chat"]["name"]).to eq(course_chat.name)
          expect(json["course_chat"]["description"]).to eq(course_chat.description)
        end
      end

      context "when chat channel does not exist" do
        before do
          get "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/course_chats/999999"
        end

        it "returns a not found error" do
          expect(response).to have_http_status(:not_found)
        end
      end

      context "when course does not exist" do
        before do
          get "#{TestConstants::DEFAULT_API_BASE_URL}/courses/999999/course_chats/#{course_chat.id}"
        end

        it "returns a not found error" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe "POST #{TestConstants::DEFAULT_API_BASE_URL}/courses/:course_id/course_chats" do
      context "with valid parameters" do
        before do
          post "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/course_chats",
            params: {
              name: "General Discussion",
              description: "A channel for general course discussions"
            }
        end

        it "creates a new chat channel" do
          expect(response).to have_http_status(:created)
          json = JSON.parse(response.body)
          expect(json["success"]).to be true
          expect(json["course_chat"]["name"]).to eq("General Discussion")
          expect(json["course_chat"]["description"]).to eq("A channel for general course discussions")
        end
      end

      context "with invalid parameters" do
        before do
          post "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/course_chats",
            params: {
              name: ""
            }
        end

        it "returns an error" do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context "when course does not exist" do
        before do
          post "#{TestConstants::DEFAULT_API_BASE_URL}/courses/999999/course_chats",
            params: {
              name: "Test Channel",
              description: "Test Description"
            }
        end

        it "returns a not found error" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe "PATCH #{TestConstants::DEFAULT_API_BASE_URL}/courses/:course_id/course_chats/:id" do
      context "when chat channel exists" do
        before do
          patch "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/course_chats/#{course_chat.id}",
            params: {
              name: "Updated Channel Name",
              description: "Updated channel description"
            }
        end

        it "updates the chat channel" do
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json["success"]).to be true
          expect(json["course_chat"]["name"]).to eq("Updated Channel Name")
          expect(json["course_chat"]["description"]).to eq("Updated channel description")
        end
      end

      context "with partial parameters" do
        before do
          patch "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/course_chats/#{course_chat.id}",
            params: {
              name: "Only Name Updated"
            }
        end

        it "updates only the provided fields" do
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json["success"]).to be true
          expect(json["course_chat"]["name"]).to eq("Only Name Updated")
          expect(json["course_chat"]["description"]).to eq(course_chat.description)
        end
      end

      context "when chat channel does not exist" do
        before do
          patch "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/course_chats/999999",
            params: {
              name: "Updated Channel Name"
            }
        end

        it "returns a not found error" do
          expect(response).to have_http_status(:not_found)
        end
      end

      context "when course does not exist" do
        before do
          patch "#{TestConstants::DEFAULT_API_BASE_URL}/courses/999999/course_chats/#{course_chat.id}",
            params: {
              name: "Updated Channel Name"
            }
        end

        it "returns a not found error" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe "DELETE #{TestConstants::DEFAULT_API_BASE_URL}/courses/:course_id/course_chats/:id" do
      context "when chat channel exists" do
        before do
          delete "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/course_chats/#{course_chat.id}"
        end

        it "deletes the chat channel" do
          expect(response).to have_http_status(:no_content)
          expect(CourseChat.find_by(id: course_chat.id)).to be_nil
        end
      end

      context "when chat channel does not exist" do
        before do
          delete "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/course_chats/999999"
        end

        it "returns a not found error" do
          expect(response).to have_http_status(:not_found)
        end
      end

      context "when course does not exist" do
        before do
          delete "#{TestConstants::DEFAULT_API_BASE_URL}/courses/999999/course_chats/#{course_chat.id}"
        end

        it "returns a not found error" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
