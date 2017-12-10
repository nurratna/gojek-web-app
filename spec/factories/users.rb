# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name { Faker::Internet.user_name }
    email { Faker::Internet.email }
    phone "085277206511"
    password "longpassword"
    password_confirmation "longpassword"
    gopay 0
  end

  factory :invalid_user, parent: :user do
    name nil
    email nil
    phone nil
    password nil
    password_confirmation nil
    gopay nil
  end
end
