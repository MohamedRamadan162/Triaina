class Api::V1::Courses::Sections::SectionUnitsController < Api::ApiController
  before_action :authorize_request

  ###########################
  # List all units for a sections
  # GET /api/v1/courses/:course_id/sections/:section_id/units
  ############################
  def index
    section_id = params[:section_id]
    units = list(SectionUnit.where(section_id: section_id))
    render_success(sections: serializer(units))
  end

  ###########################
  # List a unit by id
  # GET /api/v1/courses/:course_id/sections/:section_id/units/:id
  ############################
  def show
    unit_id = get_id_params[:id]
    unit = Rails.cache.fetch("unit_#{unit_id}") do
      SectionUnit.find(unit_id)
    end
    render_success(unit: serializer(unit))
  end

  ###########################
  # Create a new unit
  # POST /api/v1/courses/:course_id/sections/:section_id/units
  ###########################
  def create
    unit = nil
    ActiveRecord::Base.transaction do
      unit = SectionUnit.create!(create_unit_params)
      unit.content.attach(params[:content]) if params[:content].present?
    end
    Rails.cache.write("unit_#{unit.id}", unit)
    SectionUnitEventProducer.publish_create_unit(unit)
    render_success({ unit: serializer(unit) }, :created)
  end

  ###########################
  # Delete a unit by id
  # DELETE /api/v1/courses/:course_id/sections/:section_id/units/:id
  ###########################
  def destroy
    unit_id = get_id_params[:id]
    unit = Rails.cache.fetch("unit_#{unit_id}") do
      SectionUnit.find(unit_id)
    end
    unit.destroy!
    Rails.cache.delete("unit_#{unit_id}")
    SectionUnitEventProducer.publish_delete_unit(unit)
    render_success({}, :no_content)
  end


  ###########################
  # Update a unit by id
  # PATCH /api/v1/courses/:course_id/sections/:section_id/units/:id
  ###########################
  def update
    unit = Rails.cache.fetch("unit_#{update_unit_params[:id]}") do
      SectionUnit.find(update_unit_params[:id])
    end
    unit.update!(update_unit_params)
    Rails.cache.write("unit_#{unit.id}", unit)
    SectionUnitEventProducer.publish_update_unit(unit)
    render_success(unit: serializer(unit))
  end

  def transcription
    unit = Rails.cache.fetch("unit_#{params[:unit_id]}") do
      SectionUnit.find(params[:unit_id])
    end

    if unit.transcription.attached?
      render_success(transcription: JSON.parse(unit.transcription.download))
    elsif unit.content.attached? && (unit.content.content_type.start_with?("video/") || unit.content.content_type.start_with?("audio/"))
      render_error("Transcription generating", :not_found)
    else
      render_error("Transcription not available", :not_found)
    end
  end

  def summary
    unit = Rails.cache.fetch("unit_#{params[:unit_id]}") do
      SectionUnit.find(params[:unit_id])
    end

    if unit.summary.attached?
      render_success(summary: unit.summary.download)
    elsif unit.content.attached?
      render_error("Summary generating", :not_found)
    else
      render_error("Summary not available", :not_found)
    end
  end

  private

  def get_id_params
    params.permit(:id)
  end

  def create_unit_params
    params.permit(:title, :description, :section_id)
  end

  def update_unit_params
    params.permit(:id, :title, :description)
  end

  def authorize_request
    authorize(User, policy_class: Course::Section::SectionUnitPolicy)
  end
end
