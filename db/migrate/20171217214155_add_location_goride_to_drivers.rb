class AddLocationGorideToDrivers < ActiveRecord::Migration[5.1]
  def change
    add_reference :drivers, :location_goride, foreign_key: true
  end
end
