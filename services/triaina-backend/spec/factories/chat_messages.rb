FactoryBot.define do
  factory :chat_message do
    association :user
    association :chat_channel
    content { Faker::Lorem.sentence(word_count: 10) }
  end
end
