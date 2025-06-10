class Api::V1::Courses::EnrollmentsController < Api::ApiController
  def index
    course_id = params[:course_id]
    enrollments = Enrollment.where(course_id: course_id)
    render_success(enrollments: serializer(enrollments))
  end

  def show
    course_id = params[:course_id]
    enrollment_id = params[:enrollment_id]
    enrollment = Enrollment.find_by!(id: enrollment_id, course_id: course_id)
    render_success(enrollment: serializer(enrollment))
  end

  def create
    course_join_code = params[:course_join_code]
    course = Course.find_by(join_code: course_join_code)
    if course.nil?
      render_error("Course not found with join code: #{course_join_code}", :not_found)
      return
    end
    enrollment_params = {
      user_id: @current_user.id,
      course_id: course.id,
      role_id: Role.find_by(name: "student").id,
      status: :active
    }
    enrollment = Enrollment.create!(enrollment_params)
    render_success({ enrollment: serializer(enrollment) }, :created)
  end

  def destroy
    course_id = params[:course_id]
    enrollment_id = params[:enrollment_id]
    enrollment = Enrollment.find_by(id: enrollment_id, course_id: course_id)

    if enrollment.nil?
      render_error("Enrollment not found", :not_found)
      return
    end

    enrollment.destroy!
    render_success({}, :no_content)
  end
end
