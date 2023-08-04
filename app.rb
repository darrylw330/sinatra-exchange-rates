# app.rb

require 'sinatra'
require 'http'
require 'json'

# Root route to fetch the list of currencies
get '/' do
  # Fetch the list of currencies from the exchangerate.host API
  response = HTTP.get('https://api.exchangerate.host/symbols')
  data = JSON.parse(response.body)

  # Extract the symbols from the response data
  @symbols = data['symbols'].keys

  # Regular expression for currency pairs
  @currency_pairs_regex = /Currency\s+pairs/i

  # Render the view template (index.erb) with the list of symbols
  erb :index
end

# Route for currency conversion options
get '/:currency' do
  # Fetch the list of currencies from the exchangerate.host API
  response = HTTP.get('https://api.exchangerate.host/symbols')
  data = JSON.parse(response.body)

  # Extract the requested currency symbol from the URL parameter
  requested_currency = params['currency'].upcase

  # Check if the requested currency is available in the API's list of symbols
  if data['symbols'].key?(requested_currency)
    @requested_currency = requested_currency
    @other_currencies = data['symbols'].keys.reject { |currency| currency == requested_currency }

    # Render the view template (currency_conversion.erb) with the currency conversion options
    erb :currency_conversion
  else
    # If the requested currency is not available, render the view template (currency_not_found.erb)
    erb :currency_not_found
  end
end

# Route for currency conversion rate
get '/:from_currency/:to_currency' do
  # Fetch the conversion rate from the exchangerate.host API
  from_currency = params['from_currency'].upcase
  to_currency = params['to_currency'].upcase

  # Fetch the conversion rate from the API
  response = HTTP.get("https://api.exchangerate.host/convert?from=#{from_currency}&to=#{to_currency}")
  data = JSON.parse(response.body)

  # Extract the conversion rate from the response data
  @rate = data['result'].to_f

  # Render the view template (currency_conversion_rate.erb) with the conversion rate
  erb :currency_conversion_rate
end
