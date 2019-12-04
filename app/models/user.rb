class User < ApplicationRecord
  include Registrable

  has_many :todos

  before_validation :normalize_and_fill_attributes

  with_options presence: true do
    validates :name
    validates :token, length: { is: 36 }, uniqueness: true
    validates :password_digest, length: { is: 64 }, if: ->(user) { user.password_digest.present? }
  end

  private

    def normalize_and_fill_attributes
      self.name.try(:squish!)

      self.token = SecureRandom.uuid if token.blank?
    end
end
