class Location::Goride < ApplicationRecord
  has_many :drivers, :foreign_key => :location_goride_id

  geocoded_by :address
  before_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }

  validates :address, presence: true, uniqueness: true
  validate :ensure_address_latlong_found

  private
    def ensure_address_latlong_found
      if latitude.nil? || longitude.nil?
        errors.add(:address, "not found")
      end
    end
end
