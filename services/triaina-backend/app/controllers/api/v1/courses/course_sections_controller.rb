class Api::V1::Courses::CourseSectionsController < Api::ApiController
  before_action :authorize_request

  ###########################
  # List all sections for a course
  # GET /api/v1/courses/:course_id/sections
  ############################
  def index
    course_id = params[:course_id]
    sections = list(CourseSection.where(course_id: course_id))
    render_success(sections: serializer(sections))
  end

  ###########################
  # List a section by id
  # GET /api/v1/courses/:course_id/sections/:id
  ############################
  def show
    section_id = get_id_params[:id]
    section = Rails.cache.fetch("section_#{section_id}") do
      CourseSection.find(section_id)
    end
    render_success(section: serializer(section))
  end

  ###########################
  # Create a new section
  # POST /api/v1/courses/:course_id/sections
  # ############################
  def create
    section = CourseSection.create!(create_section_params)
    Rails.cache.write("section_#{section.id}", section)
    CourseSectionEventProducer.publish_create_section(section)
    render_success({ section: serializer(section) }, :created)
  end

  ###########################
  # Delete a section by id
  # DELETE /api/v1/courses/:course_id/sections/:id
  ###########################
  def destroy
    section_id = get_id_params[:id]
    section = Rails.cache.fetch("section_#{section_id}") do
      CourseSection.find(section_id)
    end
    section.destroy!
    Rails.cache.delete("section_#{section_id}")
    CourseSectionEventProducer.publish_delete_section(section)
    render_success({}, :no_content)
  end

  ###########################
  # Update a section by id
  # PATCH /api/v1/courses/:course_id/sections/:id
  # ############################
  def update
    section = Rails.cache.fetch("section_#{update_section_params[:id]}") do
      CourseSection.find(update_section_params[:id])
    end
    section.update!(update_section_params)
    Rails.cache.write("section_#{section.id}", section)
    CourseSectionEventProducer.publish_update_section(section)
    render_success({ section: serializer(section) })
  end

  private

  def get_id_params
    params.permit(:id)
  end

  def create_section_params
    params.permit(:title, :description, :course_id)
  end

  def update_section_params
    params.permit(:id, :title, :description)
  end

  private

  def authorize_request
    authorize(User, policy_class: Course::CourseSectionPolicy)
  end
end
