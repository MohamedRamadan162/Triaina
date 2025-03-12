FactoryBot.define do
  factory :user_security do
    association :user  # Ensures a user is created for this user_security record
    password { "SecurePass123!" }  # Example valid password
  end
end
