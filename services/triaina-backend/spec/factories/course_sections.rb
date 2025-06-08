FactoryBot.define do
  factory :course_section do
    association :course
    title { Faker::Educator.course_name }
    order_index { rand(1..100) }
  end
end
