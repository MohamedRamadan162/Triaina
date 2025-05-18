class SectionSerializer < ApplicationSerializer
  attributes :id, :title, :description, :order_index, :course_id

  attribute :units do
    object.section_units.map do |unit|
      UnitSerializer.render(unit)
    end
  end
end
