class Location::Goride < ApplicationRecord
  has_many :drivers, :foreign_key => :location_goride_id

  before_save { address.downcase! }
  validates :address, presence: true, uniqueness: true
end
