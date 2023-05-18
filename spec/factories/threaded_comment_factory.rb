# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    body { 'Body' }
    user
    association :post
    parent
  end
end
