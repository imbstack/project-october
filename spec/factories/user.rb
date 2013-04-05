FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "testUser#{n}" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password "TestPassword"
  end
end
