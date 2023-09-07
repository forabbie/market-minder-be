class StockSerializer
  attr_reader :stock

  def initialize(stock)
    @stock = stock
  end

  def as_json
    {
      "stock": {
        symbol: @stock.symbol,
        company_name: @stock.company_name,
        last_price: @stock.last_price
      }
    }
  end
end
