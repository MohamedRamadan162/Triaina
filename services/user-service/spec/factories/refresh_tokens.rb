FactoryBot.define do
  factory :refresh_token do
    association :user
    raw_token { SecureRandom.hex(64) }
    hashed_token { Digest::SHA256.hexdigest(raw_token) }
    issued_at { Time.current }
    expires_at { 30.days.from_now }
    revoked_at { nil }

    trait :revoked do
      revoked_at { Time.current }
    end

    trait :expired do
      expires_at { 1.day.ago }
    end
  end
end
