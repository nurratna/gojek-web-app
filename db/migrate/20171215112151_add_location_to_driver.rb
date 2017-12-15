class AddLocationToDriver < ActiveRecord::Migration[5.1]
  def change
    add_column :drivers, :location, :string
    add_column :drivers, :latitude, :string
    add_column :drivers, :longitude, :string
  end
end
