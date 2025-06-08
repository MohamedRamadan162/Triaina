FactoryBot.define do
  factory :permission do
    action { Faker::Lorem.word }
    subject { Faker::Lorem.word }
  end
end
