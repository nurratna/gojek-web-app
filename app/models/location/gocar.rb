class Location::Gocar < ApplicationRecord
  has_many :drivers, :foreign_key => :location_gocar_id

  geocoded_by :address
  before_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }

  before_save { address.downcase! }
  validates :address, presence: true, uniqueness: true
  validate :ensure_address_latlong_found

  private
    def ensure_address_latlong_found
      if latitude.nil? || longitude.nil?
        errors.add(:address, "not found")
      end
    end
end
