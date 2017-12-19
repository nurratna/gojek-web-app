class Order < ApplicationRecord
  include CalculateDistance

  belongs_to :user
  belongs_to :driver, optional: true

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

  before_save { origin.downcase! }
  before_save { destination.downcase! }
  validates :origin, presence: true
  validate :ensure_origin_latlong_found
  validates :destination, presence: true
  validate :ensure_destination_latlong_found
  validates :service_type, :payment_type, presence: true
  validates :service_type, inclusion: service_types.keys
  validates :payment_type, inclusion: payment_types.keys

  validate :ensure_origin_different_with_destination
  validate :ensure_credit_sufficient_if_using_gopay
  validate :distance_must_be_less_than_or_equal_to_max_dist_origin_destination

  after_validation :set_attributes
  after_validation :find_driver
  after_validation :topup_balance_driver_and_changes_location
  after_validation :substracts_credit_if_using_gopay_and_state_completed

  def cost_goride_per_km
    3500
  end

  def cost_gocar_per_km
    6500
  end

  def max_dist_origin_destination
    50
  end

  def max_dist_origin_driver
    1
  end

  def calculate_distance_origin_destination
    dist = 0
    if geocoder_attributes_exist?
      dist = distance_between(origin_lat, origin_long, destination_lat, destination_long).round(2)
    end
    dist
  end

  def calculate_est_price
    est_price = 0
    if service_type == 'Go Ride'
      est_price = (calculate_distance_origin_destination * cost_goride_per_km).round
      est_price = cost_goride_per_km if est_price < cost_goride_per_km
    else
      est_price = (calculate_distance_origin_destination * cost_gocar_per_km).round
      est_price = cost_gocar_per_km if est_price < cost_gocar_per_km
    end
    est_price
  end

  def set_drivers
    drivers = []
    if self.service_type == 'Go Ride'
      locations = Location::Goride.all
      locations.each do |location|
        dist = distance_between(origin_lat, origin_long, location.latitude, location.longitude).round(2)
        drivers.push(ids: location.driver_ids, dist: dist)
      end
    else
      locations = Location::Gocar.all
      locations.each do |location|
        dist = distance_between(origin_lat, origin_long, location.latitude, location.longitude).round(2)
        drivers.push(ids: location.driver_ids, dist: dist)
      end
    end
    drivers
  end

 private
    def set_attributes
      self.est_price = calculate_est_price
      self.status = 0
    end

    def find_driver
      drivers = set_drivers.sort_by { |hsh| hsh[:dist] }
      drivers.each do |driver|
        if driver[:dist] > max_dist_origin_driver
          self.status = 2 # cancel
          self.driver_id = nil
          break;
        elsif driver[:ids].empty?
          self.status = 2 # cancel
          self.driver_id = nil
          break;
        else
          self.status = 1 # Completed
          self.driver_id = driver[:ids].shuffle.first

          break;
        end
      end
    end

    def topup_balance_driver_and_changes_location
      if self.payment_type == "Go Pay" && self.status == "Completed"
        obj = Driver.find(self.driver_id)
        obj.update(gopay: obj.gopay + calculate_est_price)
        obj.update(location: destination)
      end
    end

    def ensure_credit_sufficient_if_using_gopay
      if payment_type == 'Go Pay'
        if user.gopay < calculate_est_price
          errors.add(:payment_type, ': insufficient Go Pay credit')
        end
      end
    end

    def substracts_credit_if_using_gopay_and_state_completed
      if payment_type == 'Go Pay' && status == "Completed"
        user.gopay -= calculate_est_price
        user.save
      end
    end

    def distance_must_be_less_than_or_equal_to_max_dist_origin_destination
      if calculate_distance_origin_destination > max_dist_origin_destination
        errors.add(:address, "must not be more than #{max_dist_origin_destination} km away from origin")
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

    def ensure_origin_latlong_found
      if origin_lat.nil?
        errors.add(:origin, "not found. Please check your connection or typo")
      end
    end

    def ensure_destination_latlong_found
      if destination_lat.nil?
        errors.add(:destination, "not found. Please check your connection or typo")
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
