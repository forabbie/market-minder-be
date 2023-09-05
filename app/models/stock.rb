class Stock < ApplicationRecord

  def self.new_lookup(symbol)
    client = IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex_client[:publishable_api_key],
      endpoint: 'https://cloud.iexapis.com/v1'
    )
    client.price(symbol)
  end
end
