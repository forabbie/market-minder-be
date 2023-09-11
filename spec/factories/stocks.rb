FactoryBot.define do
  factory :stock do
    association :user
    symbol { 'AAPL' }
    company_name { 'Apple Inc.' } 
    last_price { '150.00' }
    shares_quantity { '10.0' }

    trait :custom_stock do
      sequence(:symbol) { |n| "SYM#{n}" }
      sequence(:company_name) { |n| "Company#{n}" }
      last_price { '200.00' }
      shares_quantity { '5.0' }
    end
  end
end
