# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AuthController, type: :controller do
  describe 'POST #signup' do
    let(:valid_params) do
      {
        name: 'John Doe',
        username: 'johndoe',
        email: 'john@example.com',
        password: 'GreatPassword@123',
        password_confirmation: 'GreatPassword@123'
      }
    end

    context 'with valid parameters' do
      it 'creates a new user and returns success response' do
        expect {
          post :signup, params: valid_params
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
        post :signup, params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['success']).to be_falsey
      end

      it 'returns an error when email is missing' do
        invalid_params = valid_params.except(:email)
        post :signup, params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST #login' do
    let(:user) { create(:user, email: 'john@example.com', username: "johndoe") }
    let!(:user_security) { create(:user_security, user: user, password: 'Password@123', password_confirmation: 'Password@123') }

    context 'with valid credentials' do
      it 'logs in the user and sets JWT cookies' do
        post :login, params: { email: user.email, password: 'Password@123' }

        expect(response).to have_http_status(:success)
        json = JSON.parse(response.body)
        expect(json['message']).to eq('Sign in successful')
        expect(cookies.signed[:jwt]).not_to be_nil
        expect(cookies.signed[:refresh_token]).not_to be_nil
      end
    end

    context 'with invalid credentials' do
      it 'returns an error for incorrect password' do
        post :login, params: { email: user.email, password: 'wrongpassword' }

        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body)
        expect(json['success']).to be_falsey
        expect(json['message']).to eq('Invalid email or password')
      end

      it 'returns an error for non-existent user' do
        post :login, params: { email: 'nonexistent@example.com', password: 'password123' }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
