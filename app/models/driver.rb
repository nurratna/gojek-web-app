class Driver < ApplicationRecord
  has_secure_password
  has_secure_token

  geocoded_by :location
  before_validation :geocode, if: ->(obj){ obj.location.present? and obj.location_changed? }
  after_validation :geocode

  before_save { email.downcase! }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: {
    with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
    message: 'format is invalid'
  }
  validates :phone, presence: true, uniqueness: true, length: { maximum: 12 }, numericality: true
  validates :password, presence: true, on: :create
  validates :password, length: { minimum: 8 }, allow_blank: true
  validates :gopay, numericality: { greater_than_or_equal_to: 0 }
  validates :location, presence: true

  validate :geocode_or_reset_coordinates
  validate :ensure_location_latlong_found

  def topup(amount)
    if !(is_numeric?(amount))
      errors.add(:gopay, "is not a number")
      false
    elsif amount.to_i < 0
      errors.add(:gopay, "must be greater than or equal to 0")
      false
    else
      update(gopay: gopay + amount.to_i)
    end
  end

  def loc(params)
    update(location: params)
  end

  private
    def is_numeric?(obj)
      obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
    end

    def ensure_location_latlong_found
      if latitude.nil? || longitude.nil?
        errors.add(:location, "not found")
        false
      end
    end

    def geocode_or_reset_coordinates
      if geocode.nil?
        self.latitude = nil
        self.longitude = nil
      end
    end
end
