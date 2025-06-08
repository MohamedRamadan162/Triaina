FactoryBot.define do
  factory :course do
    name { Faker::Educator.course_name }
    association(:user)
    start_date { Date.today }
  end
end
