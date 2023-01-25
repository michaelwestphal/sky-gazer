require "test_helper"

class WeatherApiTest < ActiveSupport::TestCase
  setup do
    @forecast = forecasts(:one)

    conn = Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("https://api.weather.gov/points/#{@forecast.latitude},#{@forecast.longitude}") do
          [ 200, { 'Content-Type': 'application/json', }, '{ "properties": { "forecast": "some_url" } }' ]
        end

        stub.get("some_url") do
          [
            200,
            { 'Content-Type': 'application/json', },
            %{{ "properties": { "periods": [
                { "startTime": "2012-07-24T06:00:00-06:00", "temperature": 70 },
                { "startTime": "2012-07-24T18:00:00-06:00", "temperature": 75 },
                { "startTime": "2014-08-06T05:00:00-06:00", "temperature": 72 },
                { "startTime": "2014-08-06T17:00:00-06:00", "temperature": 78 }
              ] }
             }
            }
          ]
        end
      end
    end

    @client = WeatherApi::Client.new(conn)
  end

  test "get forecasts from the National Weather Service" do
    forecast_periods = @client.get_forecast(@forecast)
    assert_equal 2, forecast_periods.count
  end

  test "a forecast period should have a high temperature" do
    forecast_periods = @client.get_forecast(@forecast)
    period = forecast_periods.first
    assert_equal 75, period.high_temperature
  end

  test "a forecast period should have a low temperature" do
    forecast_periods = @client.get_forecast(@forecast)
    period = forecast_periods.first
    assert_equal 70, period.low_temperature
  end

  test "a forecast period should have a day it represents" do
    forecast_periods = @client.get_forecast(@forecast)
    period = forecast_periods.first
    assert_equal 'Tuesday', period.day
  end

  test "a forecast period usually has two parts" do
    forecast_periods = @client.get_forecast(@forecast)
    period = forecast_periods.first
    assert_not period.only_one_part?
  end

  test "a forecast period can have only one part" do
    conn = Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("https://api.weather.gov/points/#{@forecast.latitude},#{@forecast.longitude}") do
          [ 200, { 'Content-Type': 'application/json', }, '{ "properties": { "forecast": "some_url" } }' ]
        end

        stub.get("some_url") do
          [ 200, { 'Content-Type': 'application/json', },
            '{ "properties": { "periods": [{ "startTime": "2016-03-29T06:00:00-06:00", "temperature": 70 }] }}'
          ]
        end
      end
    end
    client = WeatherApi::Client.new(conn)
    forecast_periods = client.get_forecast(@forecast)
    period = forecast_periods.first

    assert period.only_one_part?
    assert_equal 70, period.high_temperature
    assert_equal 70, period.low_temperature
  end

  test "an empty array is returned when an API error occurs" do
    conn = Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("https://api.weather.gov/points/#{@forecast.latitude},#{@forecast.longitude}") do
          [ 404 ]
        end
      end
    end

    client = WeatherApi::Client.new(conn)
    assert_equal [], client.get_forecast(@forecast)
  end

  test "we do not yet handle malformed data" do
    conn = Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("https://api.weather.gov/points/#{@forecast.latitude},#{@forecast.longitude}") do
          [ 200, { 'Content-Type': 'application/json', }, '{ "properties": { "forecast": "some_url" } }' ]
        end

        stub.get("some_url") do
          [ 200, { 'Content-Type': 'application/json', }, '{ "not_properties": "something_else" }' ]
        end
      end
    end

    client = WeatherApi::Client.new(conn)
    assert_raises(NoMethodError) do
      client.get_forecast(@forecast)
    end
  end
end
