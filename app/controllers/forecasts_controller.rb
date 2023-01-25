class ForecastsController < ApplicationController
  before_action :set_forecast, only: %i[ show edit update destroy ]

  def index
    @forecasts = Forecast.all
  end

  def show
    client = WeatherApi::Client.new
    @forecast.periods = client.get_forecast(@forecast)
  end

  def new
    @forecast = Forecast.new
  end

  def edit
  end

  def create
    @forecast = Forecast.new(forecast_params)

    if @forecast.save
      redirect_to forecast_url(@forecast), notice: "Forecast was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @forecast.update(forecast_params)
      redirect_to forecast_url(@forecast), notice: "Forecast was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @forecast.destroy

    redirect_to forecasts_url, notice: "Forecast was successfully removed."
  end

  private
    def set_forecast
      @forecast = Forecast.find(params[:id])
    end

    def forecast_params
      params.require(:forecast).permit(:name, :latitude, :longitude)
    end
end
