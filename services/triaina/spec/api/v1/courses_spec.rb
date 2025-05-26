require 'swagger_helper'

RSpec.describe 'Api::V1::CoursesController', type: :request do
  let(:user) { create(:user) }
  let(:course) { create(:course) }
  def authorize_req
    post '/api/v1/auth/login', params: { email: user[:email], password: TestConstants::DEFAULT_USER[:password] }
  end

  path '/api/v1/courses' do
    get 'List all courses' do
      tags 'Courses'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '200', 'courses found' do
        before do
          authorize_req
        end

        run_test! do
          expect(JSON.parse(response.body)['success']).to be true
        end
      end

      response '401', 'unauthorized' do
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
        required: [ 'name', 'description', 'start_date' ]
      }

      response '201', 'course created' do
        let(:course) { {
          name: 'New Course',
          description: 'Course description',
          start_date: '2025-05-04T00:00:00.000Z',
          end_date: nil
        }}

        before do
          authorize_req
        end

        run_test! do
          expect(JSON.parse(response.body)['success']).to be true
        end
      end

      response '401', 'unauthorized' do
        let(:course) { {
          name: 'Invalid Course',
          description: 'No Auth',
          start_date: '2025-05-04T00:00:00.000Z'
        }}
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
        let(:id) { course["id"] }

        before do
          authorize_req
        end

        run_test! do
          expect(JSON.parse(response.body)['success']).to be true
        end
      end

      response '401', 'unauthorized' do
        let(:id) { course["id"] }
        run_test!
      end
    end

    put 'Update a course' do
      tags 'Courses'
      consumes 'application/json'
      produces 'application/json'
      security [ cookie_auth: [] ]

      parameter name: :course_params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: "Updated Course Name" },
          description: { type: :string, example: "Updated course description" },
          start_date: { type: :string, format: :date_time, example: "2025-05-04T00:00:00.000Z" },
          end_date: { type: :string, format: :date_time, nullable: true }        },
        required: []
      }

      response '200', 'course updated' do
        let(:id) { course["id"] }
        let(:course_params) { { name: 'Updated Course', description: 'Updated description' } }

        before do
          authorize_req
        end

        run_test! do
          body = JSON.parse(response.body)
          expect(body['success']).to be true
          expect(body['course']['name']).to eq('Updated Course')
        end
      end

      response '401', 'unauthorized' do
        let(:id) { course["id"] }
        let(:course_params) { { name: 'Fail' } }
        run_test!
      end
    end

    delete 'Delete a course' do
      tags 'Courses'
      security [ cookie_auth: [] ]

      response '204', 'course deleted' do
        let(:id) { course["id"] }

        before do
          authorize_req
        end

        run_test! do
          expect(Course.exists?(course["id"])).to be false
        end
      end

      response '401', 'unauthorized' do
        let(:id) { course["id"] }
        run_test!
      end
    end
  end
end
