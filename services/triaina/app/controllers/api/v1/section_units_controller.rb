class Api::V1::SectionUnitsController < Api::ApiController
  def show
    unit_id = get_id_params[:id]
    unit = Rails.cache.fetch("unit_#{unit_id}") do
      SectionUnit.find(unit_id)
    end
    render_success(unit: serializer(unit))
  end

  def create
    unit = SectionUnit.create!(create_unit_params)
    Rails.cache.write("unit_#{unit.id}", unit)
    SectionUnitEventProducer.publish_create_unit(unit)
    render_success({ unit: serializer(unit) }, :created)
  end

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

  def serializer_class
    "UnitSerializer".constantize
  end
end
