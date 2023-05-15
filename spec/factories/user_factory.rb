# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:username) { |i| "TestUser#{i}" }
    sequence(:email) { |i| "test#{i}@example.com" }
    password { '0oK9Ij*uh' }
    password_confirmation { '0oK9Ij*uh' }
    is_admin { false }
  end
end
