# frozen_string_literal: true

# Utilizing the National Weather Service API
# https://www.weather.gov/documentation/services-web-api
#
# https://www.weather.gov/documentation/services-web-api#/default/gridpoint_forecast
# https://www.weather.gov/documentation/services-web-api#/default/point
#
# Using Faraday to fetch the API data.
# https://lostisland.github.io/faraday/usage/
# https://lostisland.github.io/faraday/adapters/testing
module WeatherApi
  class Client
    def initialize(connection = nil)
      # Set the User-Agent per the National Weather Service API requirements
      @connection = connection || Faraday.new(headers: { "User-Agent": "EMAIL_OR_DOMAIN_HERE" })
    end

    def get_forecast(location)
      point_response = @connection.get("https://api.weather.gov/points/#{location.latitude},#{location.longitude}")

      # FIXME: Handle errors. We're not robust at the moment.
      #  Consider approach from
      #  https://www.nopio.com/blog/how-to-create-an-api-wrapper-of-an-external-service-in-rails/
      if point_response.success?
        forecast_api_url = parse_response_to_struct(point_response).properties.forecast
        forecast_response = @connection.get(forecast_api_url)
        if forecast_response.success?
          parse_forecast_periods(forecast_response)
        end
      end
    end

    private
      def parse_response_to_struct(response)
        JSON.parse(response.body, object_class: OpenStruct)
      end

      def parse_forecast_periods(forecast_response)
        forecast = parse_response_to_struct(forecast_response)

        # Each day in the forecast has two periods, an early one (e.g., morning, afternoon)
        # and a late one (e.g., evening). Group by the date to create tuples of these periods
        # and then wrap them within a ForecastPeriod adapter
        forecast.properties.periods
          .group_by { |period| Date.parse(period.startTime) }
          .map do |day_periods|
            now, later = day_periods.second
            ForecastPeriod.new(now, later)
          end
      end
  end

  class ForecastPeriod
    attr_accessor :beginning, :ending

    def day
      Date.parse(@beginning.startTime).strftime("%A")
    end

    def high_temperature
      if @beginning.temperature > @ending.temperature
        @beginning.temperature
      else
        @ending.temperature
      end
    end

    def low_temperature
      if @beginning.temperature < @ending.temperature
        @beginning.temperature
      else
        @ending.temperature
      end
    end

    private
      def initialize(beginning, ending)
        @beginning = beginning
        @ending = ending
      end
  end
end
