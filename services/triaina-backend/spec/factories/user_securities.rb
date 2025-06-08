FactoryBot.define do
  factory :user_security do
    association :user
    password { TestConstants::DEFAULT_USER[:password] }
    password_confirmation { TestConstants::DEFAULT_USER[:password] }
  end
end
