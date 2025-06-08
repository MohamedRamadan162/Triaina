require 'swagger_helper'

RSpec.describe 'Api::V1::UsersController', type: :request do
  path '/api/v1/users/me' do
    get 'Fetch the current user' do
      tags 'Users'
      produces 'application/json'
      consumes 'application/json'
      security [ cookie_auth: [] ]

      response '200', 'user found' do
        description 'Returns the current user details'
        response_ref 'User/Show'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to courses'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end

    patch 'Update the current user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      security [ cookie_auth: [] ]

      parameter name: :updated_user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: TestConstants::DEFAULT_USER[:name] },
          email: { type: :string, format: :email, example: TestConstants::DEFAULT_USER[:email] },
          username: {
            type: :string,
            minLength: 4,
            example: TestConstants::DEFAULT_USER[:username]
          }
        },
        required: []
      }

      response '200', 'user updated' do
        description 'Returns the updated user details'
        response_ref 'User/Update'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to courses'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end

    delete 'Delete the current user' do
      tags 'Users'
      security [ cookie_auth: [] ]

      response '204', 'user deleted' do
        description 'Deletes the current user account'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to courses'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end
  end
end
