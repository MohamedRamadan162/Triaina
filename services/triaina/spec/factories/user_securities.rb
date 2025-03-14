FactoryBot.define do
  factory :user_security do
    association :user
    password { TestConstants::DEFAULT_PASSWORD }
    password_confirmation { TestConstants::DEFAULT_PASSWORD } 
  end
end
