require 'rails_helper'

RSpec.describe "Api::V1::Courses::CourseChats::ChatMessagesController", type: :request do
  describe "Chat Messages Management" do
    let!(:user) { create(:user, admin: true) }
    let!(:course) { create(:course) }
    let!(:course_chat) { create(:course_chat, course: course) }
    let!(:chat_message) { create(:chat_message, course_chat: course_chat, user: user) }

    before do
      post "#{TestConstants::DEFAULT_API_BASE_URL}/auth/login", params: { email: user.email, password: TestConstants::DEFAULT_USER[:password] }
    end

    describe "GET #{TestConstants::DEFAULT_API_BASE_URL}/courses/:course_id/course_chats/:course_chat_id/chat_messages" do
      context "when messages exist" do
        let!(:second_message) { create(:chat_message, course_chat: course_chat, user: user) }

        before do
          get "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/course_chats/#{course_chat.id}/chat_messages"
        end

        it "returns the list of messages ordered by created_at" do
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json["success"]).to be true
          expect(json["messages"].length).to eq(2)
          expect(json["messages"].first["id"]).to eq(chat_message.id)
          expect(json["messages"].last["id"]).to eq(second_message.id)
        end
      end

      context "when no messages exist" do
        before do
          ChatMessage.destroy_all
          get "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/course_chats/#{course_chat.id}/chat_messages"
        end

        it "returns an empty list" do
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json["success"]).to be true
          expect(json["messages"]).to be_empty
        end
      end

      context "when chat channel does not exist" do
        before do
          get "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/course_chats/999999/chat_messages"
        end

        it "returns a not found error" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe "GET #{TestConstants::DEFAULT_API_BASE_URL}/courses/:course_id/course_chats/:course_chat_id/chat_messages/:id" do
      context "when message exists" do
        before do
          get "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/course_chats/#{course_chat.id}/chat_messages/#{chat_message.id}"
        end

        it "returns the message details" do
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json["success"]).to be true
          expect(json["message"]["id"]).to eq(chat_message.id)
          expect(json["message"]["content"]).to eq(chat_message.content)
        end
      end

      context "when message does not exist" do
        before do
          get "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/course_chats/#{course_chat.id}/chat_messages/999999"
        end

        it "returns a not found error" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe "POST #{TestConstants::DEFAULT_API_BASE_URL}/courses/:course_id/course_chats/:course_chat_id/chat_messages" do
      context "with valid parameters" do
        before do
          post "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/course_chats/#{course_chat.id}/chat_messages",
            params: {
              content: "Hello, this is a test message"
            }
        end

        it "creates a new message" do
          expect(response).to have_http_status(:created)
          json = JSON.parse(response.body)
          expect(json["success"]).to be true
          expect(json["message"]["content"]).to eq("Hello, this is a test message")
          expect(json["message"]["user"]["id"]).to eq(user.id)
        end
      end

      context "with invalid parameters" do
        before do
          post "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/course_chats/#{course_chat.id}/chat_messages",
            params: {
              content: ""
            }
        end

        it "returns an error" do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context "when chat channel does not exist" do
        before do
          post "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/course_chats/999999/chat_messages",
            params: {
              content: "Test message"
            }
        end

        it "returns a not found error" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe "PATCH #{TestConstants::DEFAULT_API_BASE_URL}/courses/:course_id/course_chats/:course_chat_id/chat_messages/:id" do
      context "when message exists" do
        before do
          patch "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/course_chats/#{course_chat.id}/chat_messages/#{chat_message.id}",
            params: {
              content: "Updated message content"
            }
        end

        it "updates the message" do
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json["success"]).to be true
          expect(json["message"]["content"]).to eq("Updated message content")
        end
      end

      context "when message does not exist" do
        before do
          patch "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/course_chats/#{course_chat.id}/chat_messages/999999",
            params: {
              content: "Updated message content"
            }
        end

        it "returns a not found error" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe "DELETE #{TestConstants::DEFAULT_API_BASE_URL}/courses/:course_id/course_chats/:course_chat_id/chat_messages/:id" do
      context "when message exists" do
        before do
          delete "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/course_chats/#{course_chat.id}/chat_messages/#{chat_message.id}"
        end

        it "deletes the message" do
          expect(response).to have_http_status(:no_content)
          expect(ChatMessage.find_by(id: chat_message.id)).to be_nil
        end
      end

      context "when message does not exist" do
        before do
          delete "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/course_chats/#{course_chat.id}/chat_messages/999999"
        end

        it "returns a not found error" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
