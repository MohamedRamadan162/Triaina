FactoryBot.define do
  factory :section_unit do
    association :course_section, factory: :course_section
    title { Faker::Educator.course_name }
    order_index { rand(1..100) }
  end
end
