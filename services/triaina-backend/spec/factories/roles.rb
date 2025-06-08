FactoryBot.define do
  factory :role do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }

    trait :with_permissions do
      permissions { create_list(:permission, 3) }
    end
  end
end
