# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Enrolled Courses', type: :request do
  before do
    @user = create(
      :user,
      email: TestConstants::DEFAULT_USER[:email],
      username: TestConstants::DEFAULT_USER[:username],
      name: TestConstants::DEFAULT_USER[:name]
    )
    @course = create(:course)
    @course_2 = create(:course)
    @enrollment = create(:enrollment, user: @user, course: @course)
  end

  context "when user is enrolled in a course" do
    before do
      post "#{TestConstants::DEFAULT_API_BASE_URL}/auth/login", params: { email: @user.email, password: TestConstants::DEFAULT_USER[:password] }
      get_enrolled_courses
    end
    it 'returns user enrolled courses' do
      response_body = JSON.parse(response.body)
      expect(response_body['success']).to be_truthy
      expect(response_body['courses'].length).to eq(1)
      expect(response_body['courses'][0]['id']).to eq(@course.id)
    end
  end

  private

  def get_enrolled_courses
    get "#{TestConstants::DEFAULT_API_BASE_URL}/users/#{@user.id}/courses"
  end
end
