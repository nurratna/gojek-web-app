# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :driver do
    name { Faker::Internet.user_name }
    email { Faker::Internet.email }
    phone { Faker::Number.number(12) }
    password "longpassword"
    password_confirmation "longpassword"
    gopay 0
    location 'Jakarta'
    service_type 'Go Ride'
    # assosiation :order
  end

  factory :invalid_driver, parent: :driver do
    name nil
    email nil
    phone nil
    password nil
    password_confirmation nil
    gopay nil
    location nil
    service_type nil
  end
end
