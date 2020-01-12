# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    uid { FFaker::Internet.user_name }
    display_name { FFaker::Name.name }
    email { FFaker::Internet.email }
  end

  trait :guest do
    guest { true }
  end
end
