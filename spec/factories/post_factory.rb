# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    title { 'Title' }
    body { 'Body' }
    user
    community
  end
end
