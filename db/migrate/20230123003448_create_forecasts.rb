class CreateForecasts < ActiveRecord::Migration[7.0]
  def change
    create_table :forecasts do |t|
      t.string :name, null: false
      t.decimal :latitude, precision: 6, scale: 4
      t.decimal :longitude, precision: 7, scale: 4

      t.timestamps
    end
  end
end
