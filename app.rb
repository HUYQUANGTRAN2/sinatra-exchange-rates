require "sinatra"
require "sinatra/reloader"
require "http"
require "dotenv/load"

exchange_key = ENV.fetch("EXCHANGE_RATE_KEY")

get("/") do
  api_url = "https://api.exchangerate.host/list?access_key=#{exchange_key}"

  # Use HTTP.get to retrieve the API data
  @raw_response = HTTP.get(api_url)

  # Get the body of the response as a string
  @raw_string = @raw_response.to_s

  # Convert the string to JSON
  @parsed_data = JSON.parse(@raw_string)
  
  #Turn the JSON into an array
  @currencies = @parsed_data.fetch("currencies").keys

  erb(:homepage)
end

get("/:one_currency") do
  @benchmark_currency = params.fetch("one_currency")

  api_url = "https://api.exchangerate.host/list?access_key=#{exchange_key}"

  # Use HTTP.get to retrieve the API data
  raw_response = HTTP.get(api_url)

  # Get the body of the response as a string
  raw_string = raw_response.to_s

  # Convert the string to JSON
  parsed_data = JSON.parse(raw_string)
  
  #Turn the JSON into an array
  @currencies = parsed_data.fetch("currencies").keys
  erb(:benchmark)
end 

get("/:one_currency/:another_currency") do
  @benchmark_currency = params.fetch("one_currency")
  @compare_currency = params.fetch("another_currency")

  api_url = "https://api.exchangerate.host/list?access_key=#{exchange_key}"

  # Use HTTP.get to retrieve the API data
  raw_response = HTTP.get(api_url)

  # Get the body of the response as a string
  raw_string = raw_response.to_s

  # Convert the string to JSON
  parsed_data = JSON.parse(raw_string)
  
  #Turn the JSON into an array
  @currencies = parsed_data.fetch("currencies").keys
  
  conversion_api_url = "https://api.exchangerate.host/convert?from=#{@benchmark_currency}&to=#{@compare_currency}&amount=1&access_key=#{exchange_key}"

  # Use HTTP.get to retrieve the API data
  no_raw_response = HTTP.get(conversion_api_url)

  # Get the body of the response as a string
  no_raw_string = no_raw_response.to_s

  # Convert the string to JSON
  no_parsed_data = JSON.parse(no_raw_string)
  
  #fetch the final result
  @result = no_parsed_data.fetch("result")

  erb(:compare)
end 
