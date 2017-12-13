class AddLongLatToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :origin_long, :float
    add_column :orders, :origin_lat, :float
    add_column :orders, :destination_long, :float
    add_column :orders, :destination_lat, :float
  end
end
