FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    username { Faker::Internet.unique.username(specifier: 5..10) }
    name { Faker::Name.name }
    email_verified { false }

    after(:create) do |user|
      create(:user_security, user: user)
    end

    trait :verified do
      email_verified { true }
    end
  end
end
