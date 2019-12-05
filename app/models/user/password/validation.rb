class User::Password::Validation
  attr_reader :password, :password_confirmation, :errors

  def initialize(password, password_confirmation)
    @errors = {}
    @password = password
    @password_confirmation = password_confirmation

    perform
  end

  def errors?
    errors.present?
  end

  private

    def perform
      errors[:password] = ["can't be blank"] if password.blank?
      errors[:password_confirmation] = ["can't be blank"] if password_confirmation.blank?

      if password_filled? && password != password_confirmation
        errors[:password_confirmation] = ["doesn't match password"]
      end
    end

    def password_filled?
      password.present? && password_confirmation.present?
    end
end
