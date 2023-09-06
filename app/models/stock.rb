class Stock < ApplicationRecord
  IEX_API_OPTIONS = {
    publishable_token: Rails.application.credentials.iex_client[:publishable_api_key],
    endpoint: 'https://cloud.iexapis.com/v1'
  }.freeze

  CORE_API_TOKEN = Rails.application.credentials.iex_client[:publishable_api_key]
  CORE_API_BASE_URL = 'https://api.iex.cloud/v1/data/CORE/REF_DATA'

  def self.new_lookup(symbol)
    client = IEX::Api::Client.new(IEX_API_OPTIONS)
    new(
      symbol: symbol,
      company_name: client.company(symbol).company_name,
      current_price: client.price(symbol)
    )
  # handle invalid search symbol
  rescue StandardError => exception
    Rails.logger.error("Error while looking up stock: #{exception.message}")
    nil
  end

  def self.top_active_stocks # return top 10 active stocks
    client = IEX::Api::Client.new(IEX_API_OPTIONS)
    active_stocks = client.stock_market_list(:mostactive).sort_by(&:latest_volume).reverse
    { active_stocks: active_stocks.first(20) }
  end

  def self.total_available_stocks_count
    response = RestClient::Request.execute(
      method: 'get',
      url: "#{CORE_API_BASE_URL}?token=#{CORE_API_TOKEN}",
      headers: { 'Content-Type' => 'application/json' }
    )
    JSON.parse(response.body, object_class: OpenStruct)

  end

  def self.available_stocks(page, per_page)
    offset = per_page.to_i * (page.to_i - 1)

    result = RestClient::Request.execute(
      method: 'get',
      url: "#{CORE_API_BASE_URL}?token=#{CORE_API_TOKEN}&offset=#{offset}&limit=#{per_page}",
      headers: { 'Content-Type' => 'application/json' }
    )
    stocks = JSON.parse(result.body, symbolize_names: true)
    Kaminari.paginate_array(stocks).page(page).per(per_page)
  end
end
