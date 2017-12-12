# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    origin "kemang"
    destination "Pasaraya Blok M, Melawai, South Jakarta City, Jakarta"
    service_type "Go Car"
    payment_type "Cash"
    # price "9.99"
  end

  factory :invalid_order,parent: :order do
    origin nil
    destination nil
    service_type nil
    payment_type nil
  end
end
