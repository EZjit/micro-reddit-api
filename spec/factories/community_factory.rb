# frozen_string_literal: true

FactoryBot.define do
  factory :community do
    sequence(:name) { |i| "Community#{i}" }
    description { 'Description' }
  end
end
