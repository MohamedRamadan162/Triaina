require 'swagger_helper'

RSpec.describe 'Api::V1::Courses::EnrollmentsController', type: :request do
  path '/api/v1/courses/{course_id}/enrollments' do
    parameter name: :course_id, in: :path, type: :string, description: 'Course ID'

    get 'List all enrollments in a course' do
      tags 'Enrollments'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '200', 'list of enrollments' do
        description 'Returns all enrollments for the given course'
        response_ref 'Course/Enrollment/List'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to list enrollments'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end
  end

  path '/api/v1/courses/{course_id}/enrollments/{enrollment_id}' do
    parameter name: :course_id, in: :path, type: :string, description: 'Course ID'
    parameter name: :enrollment_id, in: :path, type: :string, description: 'Enrollment ID'

    get 'Get a specific enrollment' do
      tags 'Enrollments'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '200', 'enrollment found' do
        description 'Returns the requested enrollment'
        response_ref 'Course/Enrollment/Show'
        run_test!
      end

      response '404', 'enrollment not found' do
        description 'Enrollment does not exist for given ID and course'
        response_ref 'Error/NotFound'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to enrollment'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end

    delete 'Delete an enrollment' do
      tags 'Enrollments'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '204', 'enrollment deleted' do
        description 'Enrollment successfully deleted'
        run_test!
      end

      response '404', 'enrollment not found' do
        description 'Enrollment does not exist for given ID and course'
        response_ref 'Error/NotFound'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to delete enrollment'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end
  end

  path '/api/v1/courses/enrollments' do
    post 'Create a new enrollment using course join code' do
      tags 'Enrollments'
      consumes 'application/json'
      produces 'application/json'
      security [ cookie_auth: [] ]

      parameter name: :enrollment_params, in: :body, schema: {
        type: :object,
        properties: {
          course_join_code: { type: :string, example: "JOIN123", description: "Unique join code for the course" }
        },
        required: [ :course_join_code ]
      }

      response '201', 'enrollment created' do
        description 'Returns the created enrollment'
        response_ref 'Course/Enrollment/Create'
        run_test!
      end

      response '404', 'course not found' do
        description 'No course matches the given join code'
        response_ref 'Error/NotFound'
        run_test!
      end

      response '401', 'unauthorized' do
        description 'Unauthorized access to create enrollment'
        response_ref 'Error/Unauthorized'
        run_test!
      end
    end
  end
end
