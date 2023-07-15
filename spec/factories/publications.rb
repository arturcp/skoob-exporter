# frozen_string_literal: true

FactoryBot.define do
  factory :publication do
    skoob_user_id { Faker::Number.unique.number(digits: 6) }
    title { Faker::Book.title }
    author { Faker::Book.author }
    isbn { Faker::Code.isbn }
    publisher { Faker::Book.publisher }
    year { Faker::Number.between(from: 1900, to: 2022) }
    skoob_publication_id { Faker::Number.unique.number(digits: 6) }
    publication_type { 0 }
  end
end
