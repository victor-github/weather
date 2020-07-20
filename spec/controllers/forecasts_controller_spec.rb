require 'rails_helper'

describe ForecastsController do
  before do
    allow(Stormglass).to receive_message_chain(:for_address, :air_temperature, :to_s).and_return(rand(80))
  end
    
  describe "GET /forecast" do
    it "assigns resp and fresh" do
      get :forecast, params: { location: "94040" }
      expect(assigns(:resp)).to_not be_nil
      expect(response).to render_template("forecast")
    end
    it "returns invalid address" do
      allow(Stormglass).to receive_message_chain(:for_address, :air_temperature, :to_s).and_raise(NoMethodError)
      get :forecast, params: { location: "541 Del Medio Apt 1, Mountain View, CA" }, format: :json
      expect(assigns(:resp)).to be_nil
      expect(response.body).to eq({ error: "Invalid address" }.to_json)
    end
  end
end
