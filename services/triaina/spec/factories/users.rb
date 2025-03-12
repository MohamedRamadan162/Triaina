FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    username { Faker::Internet.unique.username(specifier: 5..10) }
    name { Faker::Name.name }
    email_verified { false } # Default to false unless specified

    trait :verified do
      email_verified { true }
    end
  end
end
