# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/user/courses', type: :request do
  path '/api/v1/users/{id}/courses' do
    get 'List all courses for a user' do
      tags 'User Courses'
      description 'List all courses for a user'
      produces 'application/json'

      security [cookie_auth: []]
      parameter name: :id, in: :path, type: :integer, required: true, description: 'User ID'

      response '200', 'List of courses' do
        description 'List of courses for a user'
        response_ref 'User/Course/List'
        run_test! do
          expect(JSON.parse(response.body)['success']).to be true
        end
      end

      response '401', 'Unauthorized' do
        example_file 'errors/unauthorized'
        schema_ref 'error'
        run_test!
      end

      response '404', 'User not found' do
        example_file 'errors/not_found'
        schema_ref 'error'
        run_test!
      end
    end
  end
end
