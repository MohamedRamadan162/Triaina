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
    unit = SectionUnit.create!(create_unit_params)
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

  private

  def get_id_params
    params.permit(:id)
  end

  def create_unit_params
    params.permit(:title, :description, :section_id, :content)
  end

  def update_unit_params
    params.permit(:id, :title, :description)
  end

  def authorize_request
    authorize(User, policy_class: Course::Section::SectionUnitPolicy)
  end
end
