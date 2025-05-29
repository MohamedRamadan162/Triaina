require 'swagger_helper'

RSpec.describe 'Api::V1::Courses::ChatChannelsController', type: :request do
  path '/api/v1/courses/{course_id}/chat_channels' do
    parameter name: :course_id, in: :path, type: :string, description: 'Course ID'

    get 'List all chat channels in a course' do
      tags 'Chat Channels'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '200', 'list of chat channels' do
        description 'Returns all chat channels in the given course ordered by created_at'
        response_ref 'Course/ChatChannel/List'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to list chat channels'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end

    post 'Create a new chat channel' do
      tags 'Chat Channels'
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
        response_ref 'Course/ChatChannel/Create'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to create chat channel'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end
  end

  path '/api/v1/courses/{course_id}/chat_channels/{id}' do
    parameter name: :course_id, in: :path, type: :string, description: 'Course ID'
    parameter name: :id, in: :path, type: :string, description: 'Chat Channel ID'

    get 'Get a specific chat channel' do
      tags 'Chat Channels'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '200', 'channel found' do
        description 'Returns the requested chat channel'
        response_ref 'Course/ChatChannel/Show'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to chat channel'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end

    patch 'Update a chat channel' do
      tags 'Chat Channels'
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
        response_ref 'Course/ChatChannel/Update'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to update chat channel'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end

    delete 'Delete a chat channel' do
      tags 'Chat Channels'
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
