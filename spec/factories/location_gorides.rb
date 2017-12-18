# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location_goride, :class => 'Location::Goride' do
    address "Jakarta"
  end

  factory :invalid_location_goride, parent: :location_goride do
    address nil
  end
end
