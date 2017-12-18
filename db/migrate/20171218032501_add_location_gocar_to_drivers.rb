class AddLocationGocarToDrivers < ActiveRecord::Migration[5.1]
  def change
    add_reference :drivers, :location_gocar, foreign_key: true
  end
end
