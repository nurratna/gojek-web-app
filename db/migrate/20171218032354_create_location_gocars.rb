class CreateLocationGocars < ActiveRecord::Migration[5.1]
  def change
    create_table :location_gocars do |t|
      t.string :address
      t.string :latitude
      t.string :longitude

      t.timestamps
    end
  end
end
