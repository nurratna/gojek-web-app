# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.delete_all
Driver.delete_all


10.times do
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    phone: Faker::Number.number(12),
    password: "1234567890",
    password_confirmation: "1234567890"
  )
end

User.create!(
  name: 'User',
  email: 'nurratnasarii@gmail.com',
  phone: '085271205611',
  password: '1234567890',
  password_confirmation: '1234567890'
)

Driver.create!(
  name: 'Driver 1',
  email: 'nurratnasarii@gmail.com',
  phone: '085271205611',
  location: 'Kemang Square, Jalan Kemang, RT.14/RW.1, Bangka, South Jakarta City, Jakarta',
  service_type: 'Go Ride',
  password: '1234567890',
  password_confirmation: '1234567890'
)

4.times do
  Driver.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    phone: Faker::Number.number(12),
    location: 'tanah abang',
    service_type: 'Go Ride',
    password: "1234567890",
    password_confirmation: "1234567890"
  )
end

3.times do
  Driver.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    phone: Faker::Number.number(12),
    location: 'Blok M Square, Melawai 5, RT.3/RW.1, Melawai, South Jakarta City, Jakarta',
    service_type: 'Go Car',
    password: "1234567890",
    password_confirmation: "1234567890"
  )

  Driver.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    phone: Faker::Number.number(12),
    location: 'Thamrin City, Kebon Melati, Central Jakarta City, Jakarta',
    service_type: 'Go Ride',
    password: "1234567890",
    password_confirmation: "1234567890"
  )
end

6.times do
  Driver.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    phone: Faker::Number.number(12),
    location: 'Tanah Abang, Central Jakarta City, Jakarta',
    service_type: 'Go Ride',
    password: "1234567890",
    password_confirmation: "1234567890"
  )

  Driver.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    phone: Faker::Number.number(12),
    location: 'Sarinah Busway Station, Central Jakarta City',
    service_type: 'Go Ride',
    password: "1234567890",
    password_confirmation: "1234567890"
  )
end

6.times do
  Driver.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    phone: Faker::Number.number(12),
    location: 'Tanah Abang, Central Jakarta City, Jakarta',
    service_type: 'Go Car',
    password: "1234567890",
    password_confirmation: "1234567890"
  )

  Driver.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    phone: Faker::Number.number(12),
    location: 'Sarinah Busway Station, Central Jakarta City',
    service_type: 'Go Car',
    password: "1234567890",
    password_confirmation: "1234567890"
  )
end
