require 'rails_helper'

RSpec.describe "Api::V1::Courses::ChatChannelsController", type: :request do
  describe "Chat Channels Management" do
    let!(:user) { create(:user) }
    let!(:course) { create(:course) }
    let!(:chat_channel) { create(:chat_channel, course: course) }

    before do
      post "#{TestConstants::DEFAULT_API_BASE_URL}/auth/login", params: { email: user.email, password: TestConstants::DEFAULT_USER[:password] }
    end

    describe "GET #{TestConstants::DEFAULT_API_BASE_URL}/courses/:course_id/chat_channels" do
      context "when chat channels exist" do
        let!(:second_channel) { create(:chat_channel, course: course) }

        before do
          get "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/chat_channels"
        end

        it "returns the list of chat channels ordered by created_at" do
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json["success"]).to be true
          expect(json["chat_channels"].length).to eq(2)
          expect(json["chat_channels"].first["id"]).to eq(chat_channel.id)
          expect(json["chat_channels"].last["id"]).to eq(second_channel.id)
        end
      end

      context "when no chat channels exist" do
        before do
          ChatChannel.destroy_all
          get "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/chat_channels"
        end

        it "returns an empty list" do
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json["success"]).to be true
          expect(json["chat_channels"]).to be_empty
        end
      end

      context "when course does not exist" do
        before do
          get "#{TestConstants::DEFAULT_API_BASE_URL}/courses/999999/chat_channels"
        end

        it "returns a not found error" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe "GET #{TestConstants::DEFAULT_API_BASE_URL}/courses/:course_id/chat_channels/:id" do
      context "when chat channel exists" do
        before do
          get "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/chat_channels/#{chat_channel.id}"
        end

        it "returns the chat channel details" do
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json["success"]).to be true
          expect(json["chat_channel"]["id"]).to eq(chat_channel.id)
          expect(json["chat_channel"]["name"]).to eq(chat_channel.name)
          expect(json["chat_channel"]["description"]).to eq(chat_channel.description)
        end
      end

      context "when chat channel does not exist" do
        before do
          get "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/chat_channels/999999"
        end

        it "returns a not found error" do
          expect(response).to have_http_status(:not_found)
        end
      end

      context "when course does not exist" do
        before do
          get "#{TestConstants::DEFAULT_API_BASE_URL}/courses/999999/chat_channels/#{chat_channel.id}"
        end

        it "returns a not found error" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe "POST #{TestConstants::DEFAULT_API_BASE_URL}/courses/:course_id/chat_channels" do
      context "with valid parameters" do
        before do
          post "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/chat_channels",
            params: {
              name: "General Discussion",
              description: "A channel for general course discussions"
            }
        end

        it "creates a new chat channel" do
          expect(response).to have_http_status(:created)
          json = JSON.parse(response.body)
          expect(json["success"]).to be true
          expect(json["chat_channel"]["name"]).to eq("General Discussion")
          expect(json["chat_channel"]["description"]).to eq("A channel for general course discussions")
        end
      end

      context "with invalid parameters" do
        before do
          post "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/chat_channels",
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
          post "#{TestConstants::DEFAULT_API_BASE_URL}/courses/999999/chat_channels",
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

    describe "PATCH #{TestConstants::DEFAULT_API_BASE_URL}/courses/:course_id/chat_channels/:id" do
      context "when chat channel exists" do
        before do
          patch "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/chat_channels/#{chat_channel.id}",
            params: {
              name: "Updated Channel Name",
              description: "Updated channel description"
            }
        end

        it "updates the chat channel" do
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json["success"]).to be true
          expect(json["chat_channel"]["name"]).to eq("Updated Channel Name")
          expect(json["chat_channel"]["description"]).to eq("Updated channel description")
        end
      end

      context "with partial parameters" do
        before do
          patch "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/chat_channels/#{chat_channel.id}",
            params: {
              name: "Only Name Updated"
            }
        end

        it "updates only the provided fields" do
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json["success"]).to be true
          expect(json["chat_channel"]["name"]).to eq("Only Name Updated")
          expect(json["chat_channel"]["description"]).to eq(chat_channel.description)
        end
      end

      context "when chat channel does not exist" do
        before do
          patch "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/chat_channels/999999",
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
          patch "#{TestConstants::DEFAULT_API_BASE_URL}/courses/999999/chat_channels/#{chat_channel.id}",
            params: {
              name: "Updated Channel Name"
            }
        end

        it "returns a not found error" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe "DELETE #{TestConstants::DEFAULT_API_BASE_URL}/courses/:course_id/chat_channels/:id" do
      context "when chat channel exists" do
        before do
          delete "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/chat_channels/#{chat_channel.id}"
        end

        it "deletes the chat channel" do
          expect(response).to have_http_status(:no_content)
          expect(ChatChannel.find_by(id: chat_channel.id)).to be_nil
        end
      end

      context "when chat channel does not exist" do
        before do
          delete "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/chat_channels/999999"
        end

        it "returns a not found error" do
          expect(response).to have_http_status(:not_found)
        end
      end

      context "when course does not exist" do
        before do
          delete "#{TestConstants::DEFAULT_API_BASE_URL}/courses/999999/chat_channels/#{chat_channel.id}"
        end

        it "returns a not found error" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
