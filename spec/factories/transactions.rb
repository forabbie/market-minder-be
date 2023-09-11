FactoryBot.define do
  factory :transaction do
    association :stock
    shares_quantity { '5.0' }
    price { '155.00' }
    total_price { '775.00' }
    transaction_type { 'buy' }
    # stock_id { Stock.pluck(:id).sample }
  end
end
