require 'swagger_helper'

RSpec.describe 'Api::V1::CourseSectionsController', type: :request do
  path '/api/v1/courses/{course_id}/sections' do
    parameter name: :course_id, in: :path, type: :integer, description: 'Course ID'

    get 'List all course sections' do
      tags 'Course Sections'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '200', 'sections found' do
        description 'Returns a list of course sections'
        response_ref 'Course/Section/List'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to sections'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end

    post 'Create a new course section' do
      tags 'Course Sections'
      consumes 'application/json'
      produces 'application/json'
      security [ cookie_auth: [] ]

      parameter name: :section_params, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, example: "New Section" },
          description: { type: :string, example: "New section description" }
        },
        required: [ 'title' ]
      }

      response '201', 'section created' do
        description 'Returns the created section'
        response_ref 'Course/Section/Create'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to create section'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end
  end

  path '/api/v1/courses/{course_id}/sections/{section_id}' do
    parameter name: :course_id, in: :path, type: :integer, description: 'Course ID'
    parameter name: :section_id, in: :path, type: :integer, description: 'Course Section ID'

    get 'Get a specific course section' do
      tags 'Course Sections'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '200', 'section found' do
        description 'Returns the requested section'
        response_ref 'Course/Section/Show'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to section'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end

    put 'Update a course section' do
      tags 'Course Sections'
      consumes 'application/json'
      produces 'application/json'
      security [ cookie_auth: [] ]

      parameter name: :section_params, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, example: "Updated Section Title" },
          description: { type: :string, example: "Updated section description" }
        },
        required: []
      }

      response '200', 'section updated' do
        description 'Returns the updated section'
        response_ref 'Course/Section/Update'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to update section'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end

    delete 'Delete a course section' do
      tags 'Course Sections'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '204', 'section deleted' do
        description 'Course section successfully deleted'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to delete section'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end
  end
end
