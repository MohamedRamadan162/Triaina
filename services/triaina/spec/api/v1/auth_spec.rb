# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'API V1 Auth', swagger_doc: 'v1/swagger.yaml' do
  path '/api/v1/auth/signup' do
    post 'User Signup' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: TestConstants::DEFAULT_USER[:name] },
          username: { type: :string, example: TestConstants::DEFAULT_USER[:username],     minLength: 4  },
          email: { type: :string, format: :email, example: TestConstants::DEFAULT_USER[:email] },
          password: { type: :string, example: TestConstants::DEFAULT_USER[:password] },
          password_confirmation: { type: :string, example: TestConstants::DEFAULT_USER[:password] }
        },
        required: %w[name username email password password_confirmation]
      }

      response '201', 'user created' do
        let(:user) do
          {
            name: TestConstants::DEFAULT_USER[:name],
            username: TestConstants::DEFAULT_USER[:username],
            email: TestConstants::DEFAULT_USER[:email],
            password: TestConstants::DEFAULT_USER[:password],
            password_confirmation: TestConstants::DEFAULT_USER[:password]
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['user']['email']).to eq(user[:email])
          expect(data['user']['name']).to eq(user[:name])
          expect(data['user']['username']).to eq(user[:username])
        end
      end

      response '422', 'validation failed' do
        let(:user) do
          {
            name: TestConstants::DEFAULT_USER[:name],
            username: TestConstants::DEFAULT_USER[:username],
            email: TestConstants::DEFAULT_USER[:email],
            password: TestConstants::DEFAULT_USER[:password],
            password_confirmation: 'Mismatch123'
          }
        end

        run_test!
      end
    end
  end

  path '/api/v1/auth/login' do
    post 'User Login' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: TestConstants::DEFAULT_USER[:email] },
          password: { type: :string, example: TestConstants::DEFAULT_USER[:password] }
        },
        required: %w[email password]
      }

      response '200', 'user logged in' do
        let(:user) { create(:user) }

        let(:credentials) do
          {
            email: user.email,
            password: TestConstants::DEFAULT_USER[:password]
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eq('Sign in successful')

          # Check signed cookies for JWT and refresh token
          cookie_jar = build_cookie_jar(request, response.cookies.to_h)
          expect(cookie_jar.signed[:jwt]).to eq(JsonWebToken.encode(user_id: user.id))
          latest_token = user.user_security.refresh_tokens.order(issued_at: :desc).first&.hashed_token
          expect(Digest::SHA256.hexdigest(cookie_jar.signed[:refresh_token])).to eq(latest_token)
        end
      end

      response '401', 'invalid credentials' do
        let(:credentials) { { email: 'wrong@email.com', password: 'nope' } }
        run_test!
      end
    end
  end
end
