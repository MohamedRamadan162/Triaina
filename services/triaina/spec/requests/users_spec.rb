require 'rails_helper'

RSpec.describe "Api::V1::UsersController", type: :request do
  describe "Current User" do
    let(:user) {
        create(
          :user,
          email: TestConstants::DEFAULT_USER[:email],
          username: TestConstants::DEFAULT_USER[:username],
          name: TestConstants::DEFAULT_USER[:name],
        )
    }

    # Force user creation
    before do
      user
    end

    describe "GET #{TestConstants::DEFAULT_API_BASE_URL}/users/me" do
      context "when authenticated" do
        before do
          post "#{TestConstants::DEFAULT_API_BASE_URL}/auth/login", params: { email: user.email, password: TestConstants::DEFAULT_USER[:password] }
          get "#{TestConstants::DEFAULT_API_BASE_URL}/users/me"
        end

        it "returns the current user's details" do
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json["success"]).to be true
          expect(json["user"]["id"]).to eq(user.id)
        end
      end

      context "when not authenticated" do
        before do
          get "#{TestConstants::DEFAULT_API_BASE_URL}/users/me"
        end

        it "returns an unauthorized error" do
          expect(response).to have_http_status(:unauthorized)
          json = JSON.parse(response.body)
          expect(json["message"]).to eq("Unauthorized")
        end
      end
    end

    describe "PATCH #{TestConstants::DEFAULT_API_BASE_URL}/users/me" do
      let(:update_params) { { name: "New Name", email: "new_email@example.com" } }

      context "when authenticated" do
        before do
          post "#{TestConstants::DEFAULT_API_BASE_URL}/auth/login", params: { email: user.email, password: TestConstants::DEFAULT_USER[:password] }
          patch "#{TestConstants::DEFAULT_API_BASE_URL}/users/me", params: update_params
        end

        it "updates the user details" do
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json["user"]["name"]).to eq("New Name")
          expect(json["user"]["email"]).to eq("new_email@example.com")
        end
      end

      context "when not authenticated" do
        before { patch "#{TestConstants::DEFAULT_API_BASE_URL}/users/me", params: update_params }

        it "returns an unauthorized error" do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    describe "DELETE #{TestConstants::DEFAULT_API_BASE_URL}/users/me" do
      context "when authenticated" do
        before do
          post "#{TestConstants::DEFAULT_API_BASE_URL}/auth/login", params: { email: user.email, password: TestConstants::DEFAULT_USER[:password] }
          delete "#{TestConstants::DEFAULT_API_BASE_URL}/users/me"
        end

        it "deletes the user account" do
          expect(response).to have_http_status(:no_content)
          expect(User.find_by(id: user.id)).to be_nil
        end
      end

      context "when not authenticated" do
        before { delete "#{TestConstants::DEFAULT_API_BASE_URL}/users/me" }

        it "returns an unauthorized error" do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
