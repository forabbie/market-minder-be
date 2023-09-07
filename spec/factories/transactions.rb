FactoryBot.define do
  factory :transaction do
    user { nil }
    stock { nil }
    shares_quantity { "9.99" }
    price { "9.99" }
    total_price { "9.99" }
    type { "" }
  end
end
