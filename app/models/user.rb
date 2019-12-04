class User < ApplicationRecord
  has_many :todos

  attr_accessor :password, :password_confirmation

  before_validation :normalize_and_fill_attributes

  with_options presence: true do
    validates :name
    validates :token, length: { is: 36 }, uniqueness: true
    validates :password_digest, length: { is: 64 }, if: ->(user) { user.password_digest.present? }
  end

  validate :password_must_be_filled, on: :create
  validate :password_must_be_confirmed

  private

    def normalize_and_fill_attributes
      self.name.try(:squish!)
      self.password.try(:strip!)
      self.password_confirmation.try(:strip!)

      self.token = SecureRandom.uuid if token.blank?

      if password_filled? && password == password_confirmation
        self.password_digest = Digest::SHA256.hexdigest(password)
      end
    end

    def password_must_be_filled
      errors.add(:password, "can't be blank") if password.blank?
      errors.add(:password_confirmation, "can't be blank") if password_confirmation.blank?
    end

    def password_must_be_confirmed
      if password_filled? && password != password_confirmation
        errors.add(:password_confirmation, "doesn't match password")
      end
    end

    def password_filled?
      password.present? && password_confirmation.present?
    end
end
