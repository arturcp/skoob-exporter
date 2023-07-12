# frozen_string_literal: true

FactoryBot.define do
  factory :skoob_user do
    email { Faker::Internet.email }
    skoob_user_id { Faker::Number.unique.number(digits: 6) }
    import_status { 0 }
    not_imported { {} }
    publications_count { 0 }
  end
end
