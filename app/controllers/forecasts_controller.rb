class ForecastsController < ApplicationController

  def forecast
    if !params[:location].nil?
      @resp, @fresh = WeatherApiWrapper.new(params[:location]).get_weather_response
    end
    respond_to do |format|
      format.html 
      format.json { 
        render json: @resp.nil? ? { error: "Invalid address" } : { temperature: @resp }
      }
    end
  end

end
