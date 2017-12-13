class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :origin
      t.string :destination
      t.integer :service_type
      t.integer :payment_type
      t.integer :status
      t.decimal :est_price

      t.timestamps
    end
  end
end
