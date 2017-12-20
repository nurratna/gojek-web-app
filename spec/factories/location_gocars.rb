# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location_gocar, :class => 'Location::Gocar' do
    address "Jakarta"
  end

  factory :invalid_location_gocar, parent: :location_gocar do
    address nil
  end
end
