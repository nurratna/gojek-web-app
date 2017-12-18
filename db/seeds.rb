# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.delete_all
Driver.delete_all

User.create!(
  [
    {
      name: 'Nur Ratna Sari - User',
      email: 'nurratnasarii@gmail.com',
      phone: '085271205611',
      password: '1234567890',
      password_confirmation: '1234567890'
    }
  ]
)

Driver.create!(
  [
    {
      name: 'Nur Ratna Sari - Driver 1',
      email: 'nurratnasarii@gmail.com',
      phone: '085271205611',
      location: 'tanah abang',
      service_type: 'Go Ride',
      password: '1234567890',
      password_confirmation: '1234567890'

    }
  ]
)

Driver.create!(
  [
    {
      name: 'Nur Ratna - Driver 2',
      email: 'nurratnasari@gmail.com',
      phone: '085271205610',
      location: 'tanah abang',
      service_type: 'Go Car',
      password: '1234567890',
      password_confirmation: '1234567890'

    }
  ]
)

Driver.create!(
  [
    {
      name: 'Driver 3',
      email: 'driver3@gmail.com',
      phone: '0852712611',
      location: 'tanah abang',
      service_type: 'Go Ride',
      password: '1234567890',
      password_confirmation: '1234567890'

    }
  ]
)

Driver.create!(
  [
    {
      name: 'Driver 4',
      email: 'driver4@gmail.com',
      phone: '085271261189',
      location: 'monas',
      service_type: 'Go Ride',
      password: '1234567890',
      password_confirmation: '1234567890'

    }
  ]
)
