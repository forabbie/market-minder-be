FactoryBot.define do
  factory :user do
    email { Faker::Name.unique.first_name.downcase + "@stock.com" }
    password { "password" }
  end
end