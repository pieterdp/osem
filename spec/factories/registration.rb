# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :registration do
    user
    conference
    other_special_needs { '' }
  end
end
