require 'swagger_helper'

RSpec.describe 'Api::V1::CoursesController', type: :request do
  path '/api/v1/courses' do
    get 'List all courses' do
      tags 'Courses'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '200', 'courses found' do
        description 'Returns a list of courses'
        response_ref 'Course/List'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to courses'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end

    post 'Create a new course' do
      tags 'Courses'
      consumes 'application/json'
      produces 'application/json'
      security [ cookie_auth: [] ]

      parameter name: :course, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: "New Course" },
          description: { type: :string, example: "New course description" },
          start_date: { type: :string, format: :date_time, example: "2025-05-04T00:00:00.000Z" },
          end_date: { type: :string, format: :date_time, nullable: true }
        },
        required: [ 'name', 'start_date' ]
      }

      response '201', 'course created' do
        description 'Returns a list of courses'
        response_ref 'Course/Create'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to courses'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end
  end

  path '/api/v1/courses/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'Course ID'

    get 'Get a specific course' do
      tags 'Courses'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '200', 'course found' do
        description 'Returns a specific course'
        response_ref 'Course/Show'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to courses'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end

    put 'Update a course' do
      tags 'Courses'
      consumes 'application/json'
      produces 'application/json'
      security [ cookie_auth: [] ]

      parameter name: :course, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: "Updated Course Name" },
          description: { type: :string, example: "Updated course description" },
          start_date: { type: :string, format: :date_time, example: "2025-05-04T00:00:00.000Z" },
          end_date: { type: :string, format: :date_time, nullable: true }        },
        required: []
      }

      response '200', 'course updated' do
        description 'Returns the updated course'
        response_ref 'Course/Update'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to courses'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end

    delete 'Delete a course' do
      tags 'Courses'
      security [ cookie_auth: [] ]

      response '204', 'course deleted' do
        description 'Course successfully deleted'
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
