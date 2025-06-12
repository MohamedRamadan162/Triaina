require 'swagger_helper'

RSpec.describe 'Api::V1::Courses::CourseChatsController', type: :request do
  path '/api/v1/courses/{course_id}/course_chats' do
    parameter name: :course_id, in: :path, type: :string, description: 'Course ID'

    get 'List all course chats in a course' do
      tags 'Course Chats'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '200', 'list of course chats' do
        description 'Returns all course chats in the given course ordered by created_at'
        response_ref 'Course/CourseChat/List'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to list course chats'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end

    post 'Create a new chat channel' do
      tags 'Course Chats'
      consumes 'application/json'
      produces 'application/json'
      security [ cookie_auth: [] ]

      parameter name: :channel_params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: "General Discussion", description: "Name of the chat channel" },
          description: { type: :string, example: "A channel for general course discussions", description: "Description of the chat channel" }
        },
        required: [ :name ]
      }

      response '201', 'channel created' do
        description 'Returns the created chat channel'
        response_ref 'Course/CourseChat/Create'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to create chat channel'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end
  end

  path '/api/v1/courses/{course_id}/course_chats/{id}' do
    parameter name: :course_id, in: :path, type: :string, description: 'Course ID'
    parameter name: :id, in: :path, type: :string, description: 'Chat Channel ID'

    get 'Get a specific chat channel' do
      tags 'Course Chats'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '200', 'channel found' do
        description 'Returns the requested chat channel'
        response_ref 'Course/CourseChat/Show'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to chat channel'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end

    patch 'Update a chat channel' do
      tags 'Course Chats'
      consumes 'application/json'
      produces 'application/json'
      security [ cookie_auth: [] ]

      parameter name: :channel_params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: "Updated Channel Name" },
          description: { type: :string, example: "Updated channel description" }
        },
        required: []
      }

      response '200', 'channel updated' do
        description 'Returns the updated chat channel'
        response_ref 'Course/CourseChat/Update'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to update chat channel'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end

    delete 'Delete a chat channel' do
      tags 'Course Chats'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '204', 'channel deleted' do
        description 'Chat channel successfully deleted'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to delete chat channel'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end
  end
end
