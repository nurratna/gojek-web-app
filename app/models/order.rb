class Order < ApplicationRecord
  belongs_to :user
  belongs_to :driver

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
  # before_validation :geocode_endpoints
  after_validation :set_attributes

  validates :origin, presence: true
  validate :ensure_origin_latlong_found
  validates :destination, presence: true
  validate :ensure_destination_latlong_found
  validates :service_type, :payment_type, presence: true
  validates :service_type, inclusion: service_types.keys
  validates :payment_type, inclusion: payment_types.keys

  validate :ensure_origin_different_with_destination
  validate :ensure_credit_sufficient_if_using_gopay
  validate :distance_must_be_less_than_or_equal_to_max_dist
  before_save :substracts_credit_if_using_gopay

  def cost_goride_per_km
    1500
  end

  def cost_gocar_per_km
    2500
  end

  def max_dist
    25
  end

  def calculate_distance
   dist = 0
   if geocoder_attributes_exist?
    coor_origin = Geocoder.coordinates(origin)
    coor_destination = Geocoder.coordinates(destination)
    dist = Geocoder::Calculations.distance_between(coor_origin, coor_destination).round(2)
   end
   dist
 end

 def calculate_est_price
   est_price = 0
   if service_type == 'Go Ride'
     est_price = (calculate_distance * cost_goride_per_km).round
     est_price = cost_goride_per_km if est_price < cost_goride_per_km
   else
     est_price = (calculate_distance * cost_gocar_per_km).round
     est_price = cost_gocar_per_km if est_price < cost_gocar_per_km
   end
   est_price
 end

  private
    def set_attributes
      self.est_price = calculate_est_price
      # self.status 0

    end

    def ensure_credit_sufficient_if_using_gopay
      if payment_type == 'Go Pay'
        if user.gopay < calculate_est_price
          errors.add(:payment_type, ': insufficient Go Pay credit')
        end
      end
    end

    def substracts_credit_if_using_gopay
      if payment_type == 'Go Pay'
        user.gopay -= est_price
        user.save
      end
    end

    def distance_must_be_less_than_or_equal_to_max_dist
      if calculate_distance > max_dist
        errors.add(:address, "must not be more than #{max_dist} km away from origin")
      end
    end

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

    def ensure_origin_different_with_destination
      if origin == destination
        errors.add(:destination, "must be different with Origin")
      end
    end

    def geocoder_attributes_exist?
      !origin_lat.nil? && !origin_long.nil? && !destination_lat.nil? && !destination_long.nil?
    end
end
