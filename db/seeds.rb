def create_users
  User.destroy_all

  1.times do
    user = User.create!(
      email: "admin@stock.com", 
      password: "ChangeMe!",
      account_status: "approved",
      role: "admin",
    )
  end

  p "Created #{User.count} users"
end

def create_stocks
  Stock.destroy_all
  admin_user = User.find_by(email: "admin@stock.com")

  1.times do
    stock = Stock.create!(
      user: admin_user,
      symbol: 'GOOGL',
      company_name: 'Alphabet Inc.',
      last_price: '2800.00',
      shares_quantity: '15.0'
    )
  end

  p "Created #{Stock.count} stocks"
end

def create_transactions
  Transaction.destroy_all

  user = User.find_by(email: "admin@stock.com")
  stock = Stock.find_by(symbol: "GOOGL")

  1.times do
    transaction = Transaction.create!(
      stock: stock,
      shares_quantity: '5.0',
      price: '2900.00',
      total_price: '14500.00',
      transaction_type: 'buy'
    )
  end

  p "Created #{Transaction.count} transactions"
end

create_users
create_stocks
create_transactions