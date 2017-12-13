class Order < ApplicationRecord
  belongs_to :user

  enum service_type: {
    "Go Ride" => 0,
    "Go Car" => 1,
  }

  enum payment_type: {
    "Cash" => 0,
    "Go Pay" => 1,
  }

  enum status: {
    "On Proggress" => 0,
    "Completed" => 1,
    "Cancel" => 2,
  }

  geocoded_by :origin, :latitude  => :origin_lat, :longitude => :origin_long
  geocoded_by :destination, :latitude  => :destination_lat, :longitude => :destination_long
  before_validation :geocode, if: ->(obj){ obj.origin.present? and obj.origin_changed? }
  before_validation :geocode, if: ->(obj){ obj.destination.present? and obj.destination_changed? }
  validate :geocode_endpoints
  # before_validation :geocode_endpoints_destination

  validates :origin, presence: true
  validate :ensure_origin_latlong_found
  validates :destination, presence: true
  validate :ensure_destination_latlong_found
  validates :service_type, :payment_type, presence: true
  validates :service_type, inclusion: service_types.keys
  validates :payment_type, inclusion: payment_types.keys
  # validates :origin_lat, :origin_long, presence: true

  # validate :ensure_origin_latlong_found
  # validate :ensure_destination_latlong_found

  private
    def geocode_endpoints
      if origin_changed?
        geocoded = Geocoder.search(origin).first
        if geocoded
          self.origin_lat = geocoded.latitude
          self.origin_long = geocoded.longitude
        end
      end
    end

    def geocode_endpoints_destination
      if destination_changed?
        geocoded = Geocoder.search(destination).first
        if geocoded
          self.destination_lat = geocoded.latitude
          self.destination_long = geocoded.longitude
        end
      end
    end

    def ensure_origin_latlong_found
      if origin_lat.nil?
        errors.add(:origin, "not found")
      end
    end

    def ensure_destination_latlong_found
      if destination_lat.nil?
        errors.add(:destination, "not found")
      end
    end

    # def geocoder_attributes_exist?
    #   !origin_lat.blank? && !origin_long.blank? && !destination_lat.blank? && !destination_long.blank?
    # end
end
