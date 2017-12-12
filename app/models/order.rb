class Order < ApplicationRecord
  enum service_type: {
    "Go Ride" => 0,
    "Go Car" => 1,
  }

  enum payment_type: {
    "Cash" => 0,
    "Go Pay" => 1,
  }

  validates :origin, :destination, :service_type, :payment_type, presence: true
  validates :service_type, inclusion: service_types.keys
  validates :payment_type, inclusion: payment_types.keys
end
