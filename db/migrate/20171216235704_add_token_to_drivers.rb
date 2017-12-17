class AddTokenToDrivers < ActiveRecord::Migration[5.1]
  def change
    add_column :drivers, :token, :string
  end
end
