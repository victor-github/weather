class WeatherApiWrapper
  attr_accessor :location
  attr_accessor :resp #retrieved temperature information
  attr_accessor :fresh #weather an actual api request has been performed (vs cache)
  attr_accessor :request_type #"address" or "zip"

  def initialize(location)
    @request_type = location.match(/^\d{5}(-\d{4})?$/) ? "zip" : "address"
    @location = location
    @fresh = false
  end

  def perform_api_request
    begin
     Stormglass.for_address(@location, hours: 1).air_temperature.to_s
    rescue NoMethodError => e
      Rails.logger.info "ERROR: Invalid address"
      return nil
    end
  end

  def get_weather_response
    if @request_type == "zip"
      @resp = Rails.cache.fetch(@location, expires_in: 30.minutes) {
        @fresh = true
        perform_api_request
      }
    else
      @fresh = true
      @resp = perform_api_request
    end
    return @resp, @fresh
  end
end
