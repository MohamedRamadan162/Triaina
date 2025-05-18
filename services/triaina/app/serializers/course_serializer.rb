class CourseSerializer < ApplicationSerializer
  attributes :id, :name, :description, :join_code, :start_date, :end_date

  attribute :sections do
    object.course_sections.map do |section|
      SectionSerializer.render(section)
    end
  end
end
