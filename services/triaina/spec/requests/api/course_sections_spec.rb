require 'swagger_helper'

RSpec.describe 'Api::V1::CourseSectionsController', type: :request do
  let(:user) { create(:user) }
  let(:course) { create(:course) }
  let(:section) { create(:course_section, course: course) }

  def authorize_req
    post '/api/v1/auth/login', params: { email: user[:email], password: TestConstants::DEFAULT_USER[:password] }
  end

  path '/api/v1/course_sections' do
    post 'Create a new course section' do
      tags 'Course Sections'
      consumes 'application/json'
      produces 'application/json'
      security [ cookie_auth: [] ]

      parameter name: :section_params, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, example: "New Section" },
          description: { type: :string, example: "New section description" },
          course_id: { type: :integer, example: 1 }
        },
        required: [ 'title', 'course_id' ]
      }

      response '201', 'section created' do
        let(:section_params) { {
          title: 'New Section',
          description: 'Section description',
          course_id: course.id
        }}

        before do
          authorize_req
        end

        run_test! do
          expect(JSON.parse(response.body)['success']).to be true
        end
      end

      response '401', 'unauthorized' do
        let(:section_params) { {
          title: 'Invalid Section',
          description: 'No Auth',
          course_id: course.id
        }}
        run_test!
      end
    end
  end

  path '/api/v1/course_sections/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'Course Section ID'

    get 'Get a specific course section' do
      tags 'Course Sections'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '200', 'section found' do
        let(:id) { section.id }

        before do
          authorize_req
        end

        run_test! do
          expect(JSON.parse(response.body)['success']).to be true
        end
      end

      response '401', 'unauthorized' do
        let(:id) { section.id }
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
        let(:id) { section.id }
        let(:section_params) { { title: 'Updated Section', description: 'Updated description' } }

        before do
          authorize_req
        end

        run_test! do
          body = JSON.parse(response.body)
          expect(body['success']).to be true
          expect(body['section']['title']).to eq('Updated Section')
        end
      end

      response '401', 'unauthorized' do
        let(:id) { section.id }
        let(:section_params) { { title: 'Fail' } }
        run_test!
      end
    end

    delete 'Delete a course section' do
      tags 'Course Sections'
      security [ cookie_auth: [] ]

      response '204', 'section deleted' do
        let(:id) { section.id }

        before do
          authorize_req
        end

        run_test! do
          expect(CourseSection.exists?(section.id)).to be false
        end
      end

      response '401', 'unauthorized' do
        let(:id) { section.id }
        run_test!
      end
    end
  end
end
