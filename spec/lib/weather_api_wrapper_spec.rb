require 'rails_helper'
require 'weather_api_wrapper'

describe WeatherApiWrapper do
  let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) } 
  let(:cache) { Rails.cache }

  before do
    allow(Rails).to receive(:cache).and_return(memory_store)
    Rails.cache.clear
  end

  context "creating instance" do
    it "should correctly set location and zip request type" do
      location = "94040"
      w = WeatherApiWrapper.new(location)
      w.location.should == location
      w.request_type.should == "zip"
    end

    it "should correctly set address request type" do
      location = "541 Del Medio Ave, Mountain View CA"
      w = WeatherApiWrapper.new(location)
      w.request_type.should == "address"
    end
  end

  context "get_weather_response" do
    it "calls the api and writes to cache if this zipcode hasn't been cached yet" do
      location = "94040"
      w = WeatherApiWrapper.new(location)
      cache.exist?(location).should == false
      w.should_receive(:perform_api_request)
      w.get_weather_response
      cache.exist?(location).should == true
      w.fresh.should == true
    end
     
    it "retrieves response from cache if a zipcode that we have already cached" do
      location = "94040"
      w = WeatherApiWrapper.new(location)
      cache.write(location, 'test')
      w.should_not_receive(:perform_api_request)
      w.get_weather_response
      w.fresh.should == false
    end

    it "doesn't cache an address" do
      location = "541 Del Medio Ave, Mountain View CA"
      w = WeatherApiWrapper.new(location)
      w.should_receive(:perform_api_request).twice
      w.get_weather_response
      w.get_weather_response
      cache.exist?(location).should == false
      w.fresh.should == true
    end
      
  end

end
