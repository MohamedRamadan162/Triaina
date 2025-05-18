require 'rails_helper'

RSpec.describe "CourseSections", type: :request do
  describe "GET /SectionUnitsController" do
    it "returns http success" do
      get "/course_sections/SectionUnitsController"
      expect(response).to have_http_status(:success)
    end
  end

end
