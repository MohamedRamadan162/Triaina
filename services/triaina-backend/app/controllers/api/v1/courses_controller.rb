class Api::V1::CoursesController < Api::ApiController
  before_action :authorize_request

  ###########################
  # List all courses
  # GET /api/v1/courses
  ############################
  def index
    courses = list(Course)
    render_success(courses: serializer(courses))
  end

  ###########################
  # List a course by id
  # GET /api/v1/courses/:id
  # ############################
  def show
    params.permit(:id)
    course = Rails.cache.fetch("course_#{params[:id]}") do
      Course.find(params[:id])
    end
    render_success(course: serializer(course))
  end

  ###########################
  # Create a new course
  # POST /api/v1/courses
  ############################
  def create
    course = nil
    ActiveRecord::Base.transaction do
      course = Course.create!(create_course_params.merge(created_by: @current_user.id))
      Enrollment.create!(user_id: @current_user.id, course_id: course.id, role: 'instructor')
    end
    Rails.cache.write("course_#{course.id}", course)
    CourseEventProducer.publish_create_course(course)
    render_success({ course: serializer(course) }, :created)
  end

  ###########################
  # Delete a course by id
  # DELETE /api/v1/courses/:id
  ###########################
  def destroy
    params.permit(:id)
    course = Rails.cache.fetch("course_#{params[:id]}") do
      Course.find(params[:id])
    end
    course.destroy!
    Rails.cache.delete("course_#{params[:id]}")
    CourseEventProducer.publish_delete_course(course)
    render_success({}, :no_content)
  end

  ###########################
  # Update a course by id
  # PATCH /api/v1/courses/:id
  # ############################
  def update
    params.permit(:id)
    course = Rails.cache.fetch("course_#{params[:id]}") do
      Course.find(params[:id])
    end
    course.update!(create_course_params)
    Rails.cache.write("course_#{params[:id]}", course)
    CourseEventProducer.publish_delete_course(course)
    render_success({ course: serializer(course) })
  end

  private

  def create_course_params
    params.permit(:name, :description, :start_date, :end_date)
  end

  def update_course_params
    params.permit(:name, :description, :start_date, :end_date)
  end

  def authorize_request
    authorize(Course, policy_class: CoursePolicy)
  end
end
