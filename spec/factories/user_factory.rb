# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { 'TestUser' }
    email { 'test@example.com' }
    password { '0oK9Ij*uh' }
  end
end
