class Api::V1::StocksController < ApplicationController

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || Kaminari.config.default_per_page
    stocks = Stock.available_stocks(page, per_page)
    total_count = Stock.total_available_stocks_count

    render json: {
      stocks: stocks,
      meta: {
        total_count: total_count.count,
        current_page: stocks.current_page,
        per_page: stocks.limit_value,
        total_pages: stocks.total_pages
      }
    }
  end

  def top_active_stocks
    render json: Stock.top_active_stocks
  end

  def search
    if params[:stock].present?
      @stock = Stock.new_lookup(params[:stock])
      if @stock
        render json: StockSerializer.new(@stock).as_json
      else
        render json: "Please enter a valid symbol to search", status: 422
      end   
    else
      render json: "Please enter a symbol to search", status: 422
    end
  end
end
