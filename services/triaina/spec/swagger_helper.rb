# frozen_string_literal: true

require 'rails_helper'

shared_examples 'pagination_headers' do
  header 'Current-Page', schema: { type: :integer }, description: 'The current page that has been returned.'
  header 'Total-Pages', schema: { type: :integer }, description: 'Total number of pages.'
  header 'Total-Count', schema: { type: :integer }, description: 'The total count of the collection.'
  header 'Page-Items', schema: { type: :integer }, description: 'How many items per page.'
end

def example_file(path)
  path = "#{path}.json" unless path.ends_with? '.json'
  full_path = "doc/responses/#{path}"
  examples 'application/json' => JSON.parse(File.read(full_path)) if File.exist? full_path
end

def global_concepts_ref(reference)
  parameter '$ref' => "#/components/parameters/#{reference}"
end

def schema_ref(reference)
  schema '$ref' => "#/components/schemas/#{reference}"
end

def response_ref(reference)
  schema '$ref' => "#/components/x-responses/#{reference}"
end

def model_schema(properties = {}, required = [])
  model_schema = {
    type: 'object',
    properties: properties
  }
  model_schema[:required] = required if required.present?
  model_schema
end

def model_ref(ref, is_array: false, nullable: false)
  o = if is_array
        { type: :array,
          items: { '$ref' => "#/components/schemas/#{ref}" } }
  else
        { '$ref' => "#/components/schemas/#{ref}" }
  end
  o[:nullable] = true if nullable
  o
end

def response_model_schema_ref(ref, data_key, is_array: false, extra_data: nil, success: true)
  response = {
    type: 'object',
    required: %w[success data],
    properties: {
      success: { type: :boolean, example: success },
      message: { type: :string, description: 'response message' }
    }
  }
  response[:properties].merge!(extra_data) if extra_data
  response[:properties][data_key.to_s] =
    if is_array
      { type: :array,
        items: { '$ref' => "#/components/schemas/#{ref}" } }
    else
      { '$ref' => "#/components/schemas/#{ref}" }
    end
  response
end

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Triaina API',
        version: 'v1'
      },
      paths: {},
      servers: [
         {
          url: 'http://localhost:3000',
          description: 'Local dev server (HTTP)'
        },
        {
          url: 'https://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'triaina.com'
            }
          }
        }
      ],
      components: {
        securitySchemes: {
        jwtCookie: {
          type: :apiKey,
          in: :cookie,
          name: 'jwt'
        },
        refreshCookie: {
          type: :apiKey,
          in: :cookie,
          name: 'refresh_token'
          }
        },
        parameters: {
          id_param: {
            name: 'id',
            in: :path,
            description: 'The id to fetch with',
            required: true,
            schema: {
              type: :number,
              example: 1
            }
          },
          locale_param: {
            name: 'Accept-Language',
            in: 'header',
            type: 'string',
            description: "A localiztion param and it only accepts **ar** or **en**. \n
             > Please note: in case of passing this param in any protected endpoint
             it automatically overrides the locale of the current user",
            required: false,
            schema: {
              type: 'string',
              example: 'ar',
              default: 'en'
            }
          },
          page_param: {
            name: 'page',
            in: :query,
            description: 'The current page for paginated items, send it with value = -1 if no pagination needed',
            schema: {
              type: :number,
              example: 3
            }
          },
          items_param: {
            name: 'items',
            in: :query,
            description: 'The number of items per page',
            schema: {
              type: :number,
              example: 10
            }
          }
        },
        schemas: {
          Error: {
            type: :string,
            example: 'An error occurred'
          },
          Unit: model_schema(
            {
              id: { type: :integer, example: 1 },
              title: { type: :string, example: 'Unit 1' },
              description: { type: :string, example: 'Unit 1 description' },
              order_index: { type: :integer, example: 1 },
              section_id: { type: :integer, example: 1 },
              content_url: { type: :string, example: 'https://example.com/unit1.mp4' }
            },
            %w[id title description order_index section_id content_url]
          ),
          Section: model_schema(
            {
              id: { type: :integer, example: 1 },
              title: { type: :string, example: 'Section 1' },
              description: { type: :string, example: 'Section 1 description' },
              order_index: { type: :integer, example: 1 },
              course_id: { type: :integer, example: 1 },
              units: { type: :array, items: model_ref('Unit') }
            },
            %w[id title description order_index course_id units]
          ),
          Course: model_schema(
            {
              id: { type: :integer, example: 1 },
              name: { type: :string, example: 'Course 1' },
              description: { type: :string, example: 'Course 1 description' },
              join_code: { type: :string, example: '123456' },
              start_date: { type: :string, example: '2025-01-01' },
              end_date: { type: :string, example: '2025-01-01' },
              sections: { type: :array, items: model_ref('Section') }
            },
            %w[id name description join_code start_date end_date sections]
          ),
          User: model_schema(
            {
              id: { type: :integer, example: 1 },
              name: { type: :string, example: 'John Doe' },
              username: { type: :string, example: 'johndoe' },
              email: { type: :string, format: 'email', example: 'johndoe@email.com' },
              verified: { type: :boolean, example: true },
              created_at: { type: :string, format: 'date-time', example: '2025-01-01T00:00:00Z' },
              updated_at: { type: :string, format: 'date-time', example: '2025-01-01T00:00:00Z' }
            })
        },
        'x-responses': {
          Auth: {
            Signup: response_model_schema_ref('User', 'user'),
            Login: response_model_schema_ref('User', 'user')
          },
          User: {
            List: response_model_schema_ref('User', 'users', is_array: true),
            Show: response_model_schema_ref('User', 'user'),
            Update: response_model_schema_ref('User', 'user'),
            Course: {
              List: response_model_schema_ref('Course', 'courses', is_array: true)
            }
          },
          Course: {
            List: response_model_schema_ref('Course', 'courses', is_array: true),
            Show: response_model_schema_ref('Course', 'course'),
            Create: response_model_schema_ref('Course', 'course'),
            Update: response_model_schema_ref('Course', 'course'),
            Section: {
              List: response_model_schema_ref('Section', 'sections', is_array: true),
              Show: response_model_schema_ref('Section', 'section'),
              Create: response_model_schema_ref('Section', 'section'),
              Update: response_model_schema_ref('Section', 'section'),
              Unit: {
                List: response_model_schema_ref('Unit', 'units', is_array: true),
                Show: response_model_schema_ref('Unit', 'unit'),
                Create: response_model_schema_ref('Unit', 'unit'),
                Update: response_model_schema_ref('Unit', 'unit')
              }
            }
          },
          Error: {
            Unauthorized: response_model_schema_ref('Error', 'message', success: false),
            WrongCredentials: response_model_schema_ref('Error', 'message', success: false),
            ValidationError: response_model_schema_ref('Error', 'message', success: false)
          }
        }
      }
    }
  }


  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
