class AddColumnToDrivers < ActiveRecord::Migration[5.1]
  def change
    add_column :drivers, :token, :string
    add_column :drivers, :location, :string
    add_column :drivers, :latitude, :float
    add_column :drivers, :longitude, :float
    add_column :drivers, :service_type, :string
  end
end
