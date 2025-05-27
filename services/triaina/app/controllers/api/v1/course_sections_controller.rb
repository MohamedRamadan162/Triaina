class Api::V1::CourseSectionsController < Api::ApiController
  def show
    section_id = get_id_params[:id]
    section = Rails.cache.fetch("section_#{section_id}") do
      CourseSection.find(section_id)
    end
    render_success(section: serializer(section))
  end

  def create
    section = CourseSection.create!(create_section_params)
    Rails.cache.write("section_#{section.id}", section)
    CourseSectionEventProducer.publish_create_section(section)
    render_success({ section: serializer(section) }, :created)
  end

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

  def serializer_class
    "SectionSerializer".constantize
  end
end
