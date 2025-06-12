FactoryBot.define do
  factory :chat_message do
    association :user
    association :course_chat
    content { Faker::Lorem.sentence(word_count: 10) }
  end
end
