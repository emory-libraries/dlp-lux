# frozen_string_literal: true
FactoryBot.define do
  factory :content_block do
    reference { "reference" }
    value { "value" }
  end
end
