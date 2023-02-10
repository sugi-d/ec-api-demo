FactoryBot.define do
  factory :user do
    sequence(:email) { |i| "user#{i}@example.com" }
    password { '12345678' }
    confirmed_at { Time.zone.now }
  end
end
