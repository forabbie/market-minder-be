FactoryBot.define do
  factory :user do
    sequence(:first_name) { |n| "John#{n}" }
    sequence(:last_name) { |n| "Doe#{n}" }
    email { Faker::Name.unique.first_name.downcase + "@stock.com" }
    password { "password" }
    password_confirmation { 'password' }
    account_status { 'pending' }
    role { 'trader' }
    fund { '0.0' }
    token { nil }
    token_expiration { nil }
  end
end