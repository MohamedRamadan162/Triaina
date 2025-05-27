require 'rails_helper'

RSpec.describe "Api::V1::SectionUnitsController", type: :request do
  describe "Section Units Management" do
    let!(:user) { create(:user) }
    let!(:unit) { create(:section_unit) }
    let!(:section) { unit.course_section }
    let!(:course) { section.course }
    let!(:blob) do
      ActiveStorage::Blob.create_and_upload!(
        io: File.open(Rails.root.join("spec/fixtures/files/test_pdf.pdf"), "rb"),
        filename: "test_pdf.pdf",
        content_type: "application/pdf"
      )
    end

    before do
      post "#{TestConstants::DEFAULT_API_BASE_URL}/auth/login", params: { email: user.email, password: TestConstants::DEFAULT_USER[:password] }
    end

    describe "GET #{TestConstants::DEFAULT_API_BASE_URL}/courses/:course_id/sections/:section_id/units/:unit_id" do
      context "when unit exists" do
        before do
          get "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/sections/#{section.id}/units/#{unit.id}"
        end

        it "returns the unit details" do
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json["success"]).to be true
          expect(json["unit"]["id"]).to eq(unit.id)
          expect(json["unit"]["title"]).to eq(unit.title)
        end
      end

      context "when unit does not exist" do
        before do
          get "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/sections/#{section.id}/units/999999"
        end

        it "returns a not found error" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe "POST #{TestConstants::DEFAULT_API_BASE_URL}/courses/:course_id/sections/:section_id/units" do
      context "with valid parameters" do
        before do
          expect(SectionUnitEventProducer).to receive(:publish_create_unit).once
          post "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/sections/#{section.id}/units",
            params: {
              title: "New Unit",
              description: "Unit Description",
              section_id: section.id,
              content: blob.signed_id
            }
        end

        it "creates a new unit" do
          expect(response).to have_http_status(:created)
          json = JSON.parse(response.body)
          expect(json["success"]).to be true
          expect(json["unit"]["title"]).to eq("New Unit")
          expect(json["unit"]["description"]).to eq("Unit Description")
          expect(json["unit"]["content_url"]).to be_present
        end
      end

      context "with invalid parameters" do
        before do
          post "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/sections/#{section.id}/units",
            params: { title: "" }
        end

        it "returns an error" do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "PATCH #{TestConstants::DEFAULT_API_BASE_URL}/courses/:course_id/sections/:section_id/units/:unit_id" do
      context "when unit exists" do
        before do
          unit # ensure unit is created
          expect(SectionUnitEventProducer).to receive(:publish_update_unit).once
          patch "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/sections/#{section.id}/units/#{unit.id}",
                params: {
                  title: "Updated Title",
                  description: "Updated Description"
                }
        end

        it "updates the unit" do
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json["success"]).to be true
          expect(json["unit"]["title"]).to eq("Updated Title")
          expect(json["unit"]["description"]).to eq("Updated Description")
        end
      end

      context "when unit does not exist" do
        before do
          patch "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/sections/#{section.id}/units/999999"
        end

        it "returns a not found error" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe "DELETE #{TestConstants::DEFAULT_API_BASE_URL}/courses/:course_id/sections/:section_id/units/:unit_id" do
      context "when unit exists" do
        before do
          unit # ensure unit is created
          expect(SectionUnitEventProducer).to receive(:publish_delete_unit).once
          delete "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/sections/#{section.id}/units/#{unit.id}"
        end

        it "deletes the unit" do
          expect(response).to have_http_status(:no_content)
          expect(SectionUnit.find_by(id: unit.id)).to be_nil
        end
      end

      context "when unit does not exist" do
        before do
          delete "#{TestConstants::DEFAULT_API_BASE_URL}/courses/#{course.id}/sections/#{section.id}/units/999999"
        end

        it "returns a not found error" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
