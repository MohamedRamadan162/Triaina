require 'swagger_helper'

RSpec.describe 'Api::V1::SectionUnitsController', type: :request do
  let(:user) { create(:user) }
  let(:course) { create(:course) }
  let(:section) { create(:course_section, course: course) }
  let(:unit) { create(:section_unit, course_section: section) }

  def authorize_req
    post '/api/v1/auth/login', params: { email: user[:email], password: TestConstants::DEFAULT_USER[:password] }
  end

  path '/api/v1/section_units' do
    post 'Create a new section unit' do
      tags 'Section Units'
      consumes 'multipart/form-data'
      produces 'application/json'
      security [ cookie_auth: [] ]

      # For multipart/form-data, use formData parameters
      parameter name: :title, in: :formData, type: :string, required: true
      parameter name: :description, in: :formData, type: :string, required: false
      parameter name: :section_id, in: :formData, type: :integer, required: true
      parameter name: :content, in: :formData, type: :file, required: true

      response '201', 'unit created' do
        # Create the fixture file before tests run
        before do
          authorize_req

          # Make sure the section exists and is valid
          section # Force the section to be created

          # Create test file
          FileUtils.mkdir_p(Rails.root.join('spec', 'fixtures', 'files'))
          FileUtils.touch(Rails.root.join('spec', 'fixtures', 'files', 'test_pdf.pdf'))
        end

        # Set let values for form parameters
        let(:title) { 'Test Unit Title' }
        let(:description) { 'Test Unit Description' }
        let(:section_id) { section.id }
        let(:content) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'test_pdf.pdf'), 'application/pdf') }

        run_test! do
          expect(JSON.parse(response.body)['success']).to be true
        end
      end

      response '401', 'unauthorized' do
        # For unauthorized test, we need to provide the parameters but don't need to authorize
        let(:title) { 'Test Unit Title' }
        let(:description) { 'Test Unit Description' }
        let(:section_id) { section.id }
        let(:content) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'test_pdf.pdf'), 'application/pdf') }

        before do
          # Make sure the section exists
          section

          # Create test file
          FileUtils.mkdir_p(Rails.root.join('spec', 'fixtures', 'files'))
          FileUtils.touch(Rails.root.join('spec', 'fixtures', 'files', 'test_pdf.pdf'))
        end

        run_test!
      end
    end
  end

  # Rest of the specification remains the same
  path '/api/v1/section_units/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'Section Unit ID'

    get 'Get a specific section unit' do
      tags 'Section Units'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '200', 'unit found' do
        let(:id) { unit.id }

        before do
          authorize_req
        end

        run_test! do
          expect(JSON.parse(response.body)['success']).to be true
        end
      end

      response '401', 'unauthorized' do
        let(:id) { unit.id }
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
        let(:id) { unit.id }
        let(:unit_params) { { title: 'Updated Unit', description: 'Updated description' } }

        before do
          authorize_req
          # Make sure the unit exists
          unit
        end

        run_test! do
          body = JSON.parse(response.body)
          expect(body['success']).to be true
          expect(body['unit']['title']).to eq('Updated Unit')
        end
      end

      response '401', 'unauthorized' do
        let(:id) { unit.id }
        let(:unit_params) { { title: 'Fail' } }
        run_test!
      end
    end

    delete 'Delete a section unit' do
      tags 'Section Units'
      security [ cookie_auth: [] ]

      response '204', 'unit deleted' do
        let(:id) { unit.id }

        before do
          authorize_req
        end

        run_test! do
          expect(SectionUnit.exists?(unit.id)).to be false
        end
      end

      response '401', 'unauthorized' do
        let(:id) { unit.id }
        run_test!
      end
    end
  end
end
