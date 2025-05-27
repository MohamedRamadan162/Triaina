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
        description 'User successfully created and signed in'
        response_ref 'Auth/Signup'
        run_test!
      end

      response '422', 'validation failed' do
        description 'User creation failed due to validation errors'
        response_ref 'Error/ValidationError'
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
        description 'User successfully logged in and received authentication token'
        response_ref 'Auth/Login'
        run_test!
      end

      response '401', 'invalid credentials' do
        description 'User login failed due to invalid email or password'
        response_ref 'Error/WrongCredentials'
        run_test!
      end
    end
  end
end
