class TransactionSerializer
  attr_reader :transactions

  def initialize(transactions)
    @transactions = transactions
  end


  def as_json
    {
      "response": @transactions.map do |transaction|
      {
        transactions: {
          id: transaction.id,
          stock_id: transaction.stock_id,
          shares_quantity: transaction.shares_quantity,
          price: transaction.price,
          total_price: transaction.total_price,
          transaction_type: transaction.transaction_type
        },
        user: {
          id: transaction.stock.user.id,
          email: transaction.stock.user.email
        }
      }
      end
    }
  end
end
