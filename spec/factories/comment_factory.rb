# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    body { 'Body' }
    association :user
    association :post
    parent { nil }
  end
end
