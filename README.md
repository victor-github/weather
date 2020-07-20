# README

Installation:

  * bundle install
  * rails webpacker:install
  * rails dev:cache

Configuration:
  * config/initializers/stormglass.rb


Tests:
   * spec/lib/weather_api_wrapper.rb
   * spec/controllers/forecasts_controller_spec.rb

Usage: (development)

  * curl
      curl -H "Accept: application/json" http://localhost:3000/forecast?location=94040
  * Web
      http://localhost:3000/forecast

