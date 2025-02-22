FactoryBot.define do
  factory :user do
    user_id { SecureRandom.uuid }
    sequence(:username) { |n| "user#{n}" }
    name { Faker::Name.name }
    sequence(:email) { |n| "user#{n}@example.com" }
  end
end
