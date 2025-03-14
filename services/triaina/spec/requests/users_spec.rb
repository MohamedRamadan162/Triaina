require 'rails_helper'

RSpec.describe "Api::V1::UsersController", type: :request do
  let(:user) { create(:user, email: 'john@example.com', username: "johndoe", name: "John Doe") }
  let(:refresh_token) { create(:refresh_token, user: user) }
  let(:user_password) {TestConstants::DEFAULT_PASSWORD}

  describe "GET /api/v1/users/me" do
    context "when authenticated" do
      before do
        post "/api/v1/auth/login", params: { email: user.email, password: user_password }
        get "/api/v1/users/me"
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
        get "/api/v1/users/me"
      end

      it "returns an unauthorized error" do
        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Unauthorized")
      end
    end
  end

  describe "PATCH /api/v1/users/me" do
    let(:update_params) { { name: "New Name", email: "new_email@example.com" } }

    context "when authenticated" do
      before do
        post "/api/v1/auth/login", params: { email: user.email, password: user_password }
        patch "/api/v1/users/me", params: update_params
      end

      it "updates the user details" do
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["user"]["name"]).to eq("New Name")
        expect(json["user"]["email"]).to eq("new_email@example.com")
      end
    end

    context "when not authenticated" do
      before { patch "/api/v1/users/me", params: update_params }

      it "returns an unauthorized error" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /api/v1/users/me" do
    context "when authenticated" do
      before do
        post "/api/v1/auth/login", params: { email: user.email, password: user_password }
        delete "/api/v1/users/me"
      end

      it "deletes the user account" do
        expect(response).to have_http_status(:no_content)
        expect(User.find_by(id: user.id)).to be_nil
      end
    end

    context "when not authenticated" do
      before { delete "/api/v1/users/me" }

      it "returns an unauthorized error" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
