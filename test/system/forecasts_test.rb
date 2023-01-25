require "application_system_test_case"

class ForecastsTest < ApplicationSystemTestCase
  setup do
    @forecast = forecasts(:one)
  end

  test "visiting the index" do
    visit forecasts_url
    assert_selector "h1", text: "Sky Gazer"

    assert_text "Location: #{@forecast.name}"
    assert_text "Lat: #{@forecast.latitude}, Lng: #{@forecast.longitude}"

    # Note: The larger wait is due to the National Weather Service API which on occasion is slow.
    click_on "Show this forecast", match: :first, wait: 5

    # TODO: How might I provide a fake API response when doing this type of test?
    #  An option might be to have tiny Sinatra app that returns fake data
    #  I also need to better understand how to extract environment-based API URLs
    #  instead of hard coding them in say my WeatherApi module

    assert_text "Location: #{@forecast.name}"
    assert_text "Lat: #{@forecast.latitude}, Lng: #{@forecast.longitude}"

    # For any given seven day forecast, there should be text for each day of the week
    assert_text "Sunday"
    assert_text "Monday"
    assert_text "Tuesday"
    assert_text "Wednesday"
    assert_text "Thursday"
    assert_text "Friday"
    assert_text "Saturday"
  end

  # TODO: Figure out how we might utilize MapQuest element when adding a location
  #  I need to know how to click on the dynamic result.
  #  (Or better yet, perhaps, provide a proxy to a fake API)
  # test "should create forecast" do
  #   visit forecasts_url
  #   click_on "Add forecast"

  #   fill_in "Search", with: <some value here>
  #   click_on "Create Forecast"

  #   assert_text "Forecast was successfully created"
  #   click_on "Back"
  # end

  test "should destroy Forecast" do
    visit forecast_url(@forecast)
    click_on "Destroy this forecast", match: :first

    assert_text "Forecast was successfully removed"
  end
end
