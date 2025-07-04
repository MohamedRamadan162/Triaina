require 'swagger_helper'

RSpec.describe 'Api::V1::SectionUnitsController', type: :request do
  path '/api/v1/courses/{course_id}/sections/{section_id}/units' do
    get 'List all section units for a course section' do
      tags 'Section Units'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '200', 'list of section units' do
        description 'Returns all units under the given course section'
        response_ref 'Course/Section/Unit/List'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to list section units'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end

    post 'Create a new section unit' do
      tags 'Section Units'
      consumes 'multipart/form-data'
      produces 'application/json'
      security [ cookie_auth: [] ]

    parameter name: :unit_params, in: :formData, schema: {
      type: :object,
      properties: {
        title: { type: :string, example: "Updated Unit Title", description: "Title of the section unit" },
        description: { type: :string, example: "Updated unit description", description: "Description of the section unit" },
        section_id: { type: :integer, example: 123, description: "ID of the parent course section" },
        content: { type: :string, format: :binary, description: "File content of the section unit" }
      },
      required: [ :title, :content ]
  }

      response '201', 'unit created' do
        description 'Returns the created section unit'
        response_ref 'Course/Section/Unit/Create'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to create section unit'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end
  end

  path '/api/v1/courses/{course_id}/sections/{section_id}/units/{unit_id}' do
    parameter name: :unit_id, in: :path, type: :string, description: 'Section Unit ID'

    get 'Get a specific section unit' do
      tags 'Section Units'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '200', 'unit found' do
        description 'Returns the requested section unit'
        response_ref 'Course/Section/Unit/Show'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to section unit'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end

    put 'Update a section unit' do
      tags 'Section Units'
      consumes 'application/json'
      produces 'application/json'
      security [ cookie_auth: [] ]

      parameter name: :unit_params, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, example: "Updated Unit Title" },
          description: { type: :string, example: "Updated unit description" }
        },
        required: []
      }

      response '200', 'unit updated' do
        description 'Returns the updated section unit'
        response_ref 'Course/Section/Unit/Update'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to update section unit'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end

    delete 'Delete a section unit' do
      tags 'Section Units'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '204', 'unit deleted' do
        description 'Section unit successfully deleted'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to delete section unit'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end
  end

  path '/api/v1/courses/{course_id}/sections/{section_id}/units/{unit_id}/transcription' do
    post 'Get transcription' do
      tags 'Section Units'
      produces 'application/json'
      security [ cookie_auth: [] ]
      parameter name: :unit_id, in: :path, type: :string, description: 'Section Unit ID'

      response '200', 'transcription generation started' do
        description 'Transcription job has been triggered'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end
  end

  path '/api/v1/courses/{course_id}/sections/{section_id}/units/{unit_id}/summary' do
    post 'Get summary' do
      tags 'Section Units'
      produces 'application/json'
      security [ cookie_auth: [] ]
      parameter name: :unit_id, in: :path, type: :string, description: 'Section Unit ID'

      response '200', 'summary generation started' do
        description 'Summary job has been triggered'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end
  end
end
