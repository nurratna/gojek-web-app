class CreateDrivers < ActiveRecord::Migration[5.1]
  def change
    create_table :drivers do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :password_digest
      t.integer :gopay, null: false, default: 0

      t.timestamps
    end
  end
end
