class AddLocationToDriver < ActiveRecord::Migration[5.1]
  def change
    add_column :drivers, :location, :string, null: false, default: "Jakarta"
    add_column :drivers, :latitude, :float
    add_column :drivers, :longitude, :float
  end
end