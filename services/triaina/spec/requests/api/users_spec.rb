require 'swagger_helper'

RSpec.describe 'Api::V1::UsersController', type: :request do
  path '/api/v1/users/me' do
    get 'Fetch the current user' do
      tags 'Users'
      produces 'application/json'
      consumes 'application/json'
      security [ cookie_auth: [] ]

      response '200', 'user found' do
        let(:user) { create(:user) }

        before do
          post '/api/v1/auth/login', params: { email: user[:email], password: TestConstants::DEFAULT_USER[:password] }
        end

        run_test! do
          expect(JSON.parse(response.body)['user']['id']).to eq(user.id)
        end
      end

      response '401', 'unauthorized' do
        run_test! do
          expect(JSON.parse(response.body)['message']).to eq('Unauthorized')
        end
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
        let(:user) { create(:user) }
        let(:updated_user) { { name: 'New Name', email: 'new_email@example.com' } }

        before do
          post '/api/v1/auth/login', params: { email: user[:email], password: TestConstants::DEFAULT_USER[:password] }
        end

        run_test! do
          body = JSON.parse(response.body)
          expect(body['user']['id']).to eq(user.id)
          expect(body['user']['name']).to eq('New Name')
          expect(body['user']['email']).to eq('new_email@example.com')
        end
      end

      response '401', 'unauthorized' do
        let(:updated_user) { { name: 'New Name' } }
        run_test!
      end
    end

    delete 'Delete the current user' do
      tags 'Users'
      security [ cookie_auth: [] ]

      response '204', 'user deleted' do
        let(:user) { create(:user) }

        before do
          post '/api/v1/auth/login', params: { email: user.email, password: TestConstants::DEFAULT_USER[:password] }
        end

        run_test! do
          expect(User.find_by(id: user.id)).to be_nil
        end
      end

      response '401', 'unauthorized' do
        run_test!
      end
    end
  end
end
