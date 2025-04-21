FactoryBot.define do
  factory :course do
    name { Faker::Educator.course_name }
    created_by { association(:user) }
  end
end
