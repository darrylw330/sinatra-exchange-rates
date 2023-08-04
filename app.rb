# app.rb

require 'sinatra'
require 'http'
require 'json'

get '/' do
  # Fetch the list of currencies from the exchangerate.host API
  response = HTTP.get('https://api.exchangerate.host/symbols')
  data = JSON.parse(response.body)

  # Extract the symbols from the response data
  @symbols = data['symbols'].keys

  # Render the view template (index.erb) with the list of symbols
  erb :index
end

# New route for currency conversion options
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
    # If the requested currency is not available, return an error message
    "Currency not found."
  end
end
