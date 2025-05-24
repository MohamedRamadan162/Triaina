FactoryBot.define do
  factory :enrollment do
    user
    course
    role
    status { 'active' }
  end
end