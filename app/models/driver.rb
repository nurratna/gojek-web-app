class Driver < ApplicationRecord
  has_secure_password

  before_save { email.downcase! }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true, uniqueness: true, length: { maximum: 12 }, numericality: true
  validates :password, presence: true, on: :create
  validates :password, length: { minimum: 8 }, allow_blank: true
  validates :gopay, numericality: { greater_than_or_equal_to: 0 }

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

  private
    def is_numeric?(obj)
      obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
    end
end
