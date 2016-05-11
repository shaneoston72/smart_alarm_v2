require_relative '../../lib/weather_api'

class WeathersController < ApplicationController
  before_action :set_weather, only: [:show, :update, :destroy]

  # GET /weathers
  # GET /weathers.json
  def index
    @weather = get_weather
    render json: @weather
  end

  # GET /weathers/1
  # GET /weathers/1.json
  def show
    render json: @weather
  end

  # POST /weathers
  # POST /weathers.json
  def create
    @weather = Weather.new(weather_params)

    if @weather.save
      render json: @weather, status: :created, location: @weather
    else
      render json: @weather.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /weathers/1
  # PATCH/PUT /weathers/1.json
  def update
    @weather = Weather.find(params[:id])

    if @weather.update(weather_params)
      head :no_content
    else
      render json: @weather.errors, status: :unprocessable_entity
    end
  end

  # DELETE /weathers/1
  # DELETE /weathers/1.json
  def destroy
    @weather.destroy

    head :no_content
  end

  private

  def get_weather
    weather = WeatherApi.new.grab_json
    desc = weather['weather'][0]['description']
    temp = (weather['main']['temp'].to_i - 273.15).round(1)
    { description: desc, temperature: temp }.to_json
  end

  def set_weather
    @weather = Weather.find(params[:id])
  end

  def weather_params
    params[:weather]
  end
end
