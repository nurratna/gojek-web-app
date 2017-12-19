class Location::Gocar < ApplicationRecord
  has_many :drivers, :foreign_key => :location_gocar_id

  before_save { address.downcase! }
  validates :address, presence: true, uniqueness: true
end
