require 'swagger_helper'

RSpec.describe 'Api::V1::Courses::ChatChannels::ChatMessagesController', type: :request do
  path '/api/v1/courses/{course_id}/chat_channels/{chat_channel_id}/chat_messages' do
    parameter name: :course_id, in: :path, type: :string, description: 'Course ID'
    parameter name: :chat_channel_id, in: :path, type: :string, description: 'Chat Channel ID'

    get 'List all messages in a chat channel' do
      tags 'Chat Messages'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '200', 'list of chat messages' do
        description 'Returns all messages in the given chat channel ordered by created_at'
        response_ref 'Course/ChatChannel/ChatMessage/List'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to list chat messages'
        response_ref 'Error/Unauthorized'
        run_test!
      end

      response '404', 'not found' do
        description 'Course or chat channel not found'
        response_ref 'Error/NotFound'
        run_test!
      end
    end

    post 'Create a new message in a chat channel' do
      tags 'Chat Messages'
      consumes 'application/json'
      produces 'application/json'
      security [ cookie_auth: [] ]

      parameter name: :message_params, in: :body, schema: {
        type: :object,
        properties: {
          content: { type: :string, example: "Hello, this is a test message", description: "Content of the chat message" },
          attachment_url: { type: :string, example: "https://example.com/file.pdf", description: "URL of an attached file (optional)" }
        },
        required: [ :content ]
      }

      response '201', 'message created' do
        description 'Returns the created chat message'
        response_ref 'Course/ChatChannel/ChatMessage/Create'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to create chat message'
        response_ref 'Error/Unauthorized'
        run_test!
      end

      response '404', 'not found' do
        description 'Course or chat channel not found'
        response_ref 'Error/NotFound'
        run_test!
      end

      response '422', 'unprocessable entity' do
        description 'Invalid parameters provided'
        response_ref 'Error/UnprocessableEntity'
        run_test!
      end
    end
  end

  path '/api/v1/courses/{course_id}/chat_channels/{chat_channel_id}/chat_messages/{id}' do
    parameter name: :course_id, in: :path, type: :string, description: 'Course ID'
    parameter name: :chat_channel_id, in: :path, type: :string, description: 'Chat Channel ID'
    parameter name: :id, in: :path, type: :string, description: 'Chat Message ID'

    get 'Retrieves a chat message by id' do
      tags 'Chat Messages'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '200', 'message found' do
        description 'Returns the requested chat message'
        response_ref 'Course/ChatChannel/ChatMessage/Show'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to chat message'
        response_ref 'Error/Unauthorized'
        run_test!
      end

      response '404', 'not found' do
        description 'Course, chat channel, or message not found'
        response_ref 'Error/NotFound'
        run_test!
      end
    end

    patch 'Update a chat message by id' do
      tags 'Chat Messages'
      consumes 'application/json'
      produces 'application/json'
      security [ cookie_auth: [] ]

      parameter name: :message_params, in: :body, schema: {
        type: :object,
        properties: {
          content: { type: :string, example: "Updated message content", description: "Updated content of the chat message" },
          edited: { type: :boolean, example: true, description: "Mark message as edited" }
        },
        required: []
      }

      response '200', 'message updated' do
        description 'Returns the updated chat message'
        response_ref 'Course/ChatChannel/ChatMessage/Update'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to update chat message'
        response_ref 'Error/Unauthorized'
        run_test!
      end

      response '404', 'not found' do
        description 'Course, chat channel, or message not found'
        response_ref 'Error/NotFound'
        run_test!
      end

      response '422', 'unprocessable entity' do
        description 'Invalid parameters provided'
        response_ref 'Error/UnprocessableEntity'
        run_test!
      end
    end

    delete 'Deletes a chat message by id' do
      tags 'Chat Messages'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '204', 'message deleted' do
        description 'Chat message successfully deleted'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to delete chat message'
        response_ref 'Error/Unauthorized'
        run_test!
      end

      response '404', 'not found' do
        description 'Course, chat channel, or message not found'
        response_ref 'Error/NotFound'
        run_test!
      end
    end
  end
end
