class User
  module Registrable
    extend ActiveSupport::Concern

    included do
      attr_accessor :password, :password_confirmation

      before_validation :try_to_set_password_digest

      validate :password_must_be_filled, on: :create
      validate :password_must_be_confirmed
    end

    private

      def try_to_set_password_digest
        self.password.try(:strip!)
        self.password_confirmation.try(:strip!)

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
end
