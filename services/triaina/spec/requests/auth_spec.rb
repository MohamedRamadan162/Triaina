# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AuthController, type: :request do
  describe "POST #{TestConstants::DEFAULT_API_BASE_URL}/auth/signup" do
    let(:valid_params) do
      {
        name: TestConstants::DEFAULT_USER[:name],
        username: TestConstants::DEFAULT_USER[:username],
        email: TestConstants::DEFAULT_USER[:email],
        password: TestConstants::DEFAULT_USER[:password],
        password_confirmation: TestConstants::DEFAULT_USER[:password]
      }
    end

    context 'with valid parameters' do
      it 'creates a new user and returns success response' do
        expect {
          post "#{TestConstants::DEFAULT_API_BASE_URL}/auth/signup", params: valid_params
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['success']).to be_truthy
        expect(json['user']['email']).to eq(valid_params[:email])
      end
    end

    context 'with invalid parameters' do
      it 'returns an error when passwords do not match' do
        invalid_params = valid_params.merge(password_confirmation: 'wrongpassword')
        post "#{TestConstants::DEFAULT_API_BASE_URL}/auth/signup", params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['success']).to be_falsey
      end

      it 'returns an error when email is missing' do
        invalid_params = valid_params.except(:email)
        post "#{TestConstants::DEFAULT_API_BASE_URL}/auth/signup", params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "POST #{TestConstants::DEFAULT_API_BASE_URL}/auth/login" do
    let(:user) { create(:user) }

    context 'with valid credentials' do
      it 'logs in the user and sets JWT cookies' do
        post "#{TestConstants::DEFAULT_API_BASE_URL}/auth/login", params: { email: user.email, password: TestConstants::DEFAULT_USER[:password] }

        expect(response).to have_http_status(:success)
        json = JSON.parse(response.body)
        expect(json['message']).to eq('Sign in successful')
        cookie_jar = build_cookie_jar(request, response.cookies.to_h)
        expect(cookie_jar.signed[:jwt]).to be_present
        expect(cookie_jar.signed[:refresh_token]).to be_present
        expect(cookie_jar.signed[:jwt]).to eq(JsonWebToken.encode(user_id: user.id))
      end
    end

    context 'with invalid credentials' do
      it 'returns an error for incorrect password' do
        post "#{TestConstants::DEFAULT_API_BASE_URL}/auth/login", params: { email: user.email, password: 'wrongpassword' }

        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body)
        expect(json['success']).to be_falsey
        expect(json['message']).to eq('Invalid email or password')
      end

      it 'returns an error for non-existent user' do
        post "#{TestConstants::DEFAULT_API_BASE_URL}/auth/login", params: { email: 'nonexistent@example.com', password: 'password123' }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
