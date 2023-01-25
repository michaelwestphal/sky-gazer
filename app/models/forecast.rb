class Forecast < ApplicationRecord
  validates :name, :latitude, :longitude, presence: true

  attr_writer :periods
  def periods
    # A hugely mild and crude means of trying to help the template not explode
    # when the weather API doesn't properly return results since I don't have
    # robust error handling there at the moment
    @periods ||= []
  end
end
