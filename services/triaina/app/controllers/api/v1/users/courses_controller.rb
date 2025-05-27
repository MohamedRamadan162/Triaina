# frozen_string_literal: true

class Api::V1::Users::CoursesController < Api::ApiController
  before_action :authorize_request

  ###########################
  # List all courses for a user
  # GET /api/v1/users/:id/courses
  ############################
  def index
    courses = list(scope)
    render_success(courses: serializer(courses))
  end

  private

  def scope
    policy_scope(Course, policy_scope_class: UserPolicy::Scope)
  end

  def authorize_request
    authorize(User, policy_class: UserPolicy)
  end
end
