# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    origin "Tanah Abang, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta"
    destination "Pasaraya Blok M, Melawai, South Jakarta City, Jakarta"
    service_type "Go Car"
    payment_type "Cash"
    status "Completed"
    est_price 7000
    association :user
    association :driver
  end

  factory :invalid_order,parent: :order do
    origin nil
    destination nil
    service_type nil
    payment_type nil
  end
end
