require "test_helper"

class ForecastTest < ActiveSupport::TestCase
  test "should not save forecast without required fields" do
    forecast = Forecast.new
    assert_not forecast.save
    assert forecast.errors.count == 3
  end

  test "should save forecast with required fields" do
    forecast = Forecast.new(name: 'some name', latitude: 1, longitude: 2)
    assert forecast.save
    assert_empty forecast.periods
  end
end
