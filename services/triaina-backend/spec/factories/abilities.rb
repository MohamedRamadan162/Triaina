# frozen_string_literal: true

FactoryBot.define do
  factory :ability do
    name { Faker::Lorem.word }
    permission { create(:permission) }
  end
end
