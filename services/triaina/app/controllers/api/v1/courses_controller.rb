class Api::V1::CoursesController < Api::ApiController
  def index
    courses = list(Course)
    render_success(courses: serializer(courses))
  end

  def show
    params.permit(:id)
    course = Rails.cache.fetch("course_#{params[:id]}") do
      Course.find(params[:id])
    end
    render_success(course: serializer(course))
  end

  def create
    course = Course.create!(create_course_params.merge(created_by: @current_user.id))
    Rails.cache.write("course_#{course.id}", course)
    CourseEventProducer.publish_create_course(course)
    render_success({ course: serializer(course) }, :created)
  end

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

  def filtering_params
    params.permit(:id, :name, :join_code, :created_by)
  end
end
