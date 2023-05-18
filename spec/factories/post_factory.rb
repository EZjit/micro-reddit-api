# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    sequence(:title) { |i| "Post number #{i}" }
    body { 'Body' }
    association :user
    association :community
  end
end
