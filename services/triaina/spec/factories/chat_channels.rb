FactoryBot.define do
  factory :chat_channel do
    association :course
    name { Faker::Lorem.words(number: 3).join(" ") }
    description { Faker::Lorem.sentence(word_count: 10) }
  end
end
