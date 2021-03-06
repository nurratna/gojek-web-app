# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171220150559) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "drivers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "password_digest"
    t.integer "gopay", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
    t.string "location"
    t.float "latitude"
    t.float "longitude"
    t.string "service_type"
    t.bigint "location_goride_id"
    t.bigint "location_gocar_id"
    t.index ["location_gocar_id"], name: "index_drivers_on_location_gocar_id"
    t.index ["location_goride_id"], name: "index_drivers_on_location_goride_id"
  end

  create_table "location_gocars", force: :cascade do |t|
    t.string "address"
    t.string "latitude"
    t.string "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "location_gorides", force: :cascade do |t|
    t.string "address"
    t.string "latitude"
    t.string "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string "origin"
    t.string "destination"
    t.integer "service_type"
    t.integer "payment_type"
    t.integer "status"
    t.decimal "est_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "driver_id"
    t.float "origin_long"
    t.float "origin_lat"
    t.float "destination_long"
    t.float "destination_lat"
    t.integer "state"
    t.index ["driver_id"], name: "index_orders_on_driver_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "password_digest"
    t.integer "gopay", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
  end

  add_foreign_key "drivers", "location_gocars"
  add_foreign_key "drivers", "location_gorides"
  add_foreign_key "orders", "drivers"
  add_foreign_key "orders", "users"
end
