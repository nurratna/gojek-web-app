class AddUserIdAndDriverIdToOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :orders, :user, foreign_key: true
    add_reference :orders, :driver, foreign_key: true
  end
end
