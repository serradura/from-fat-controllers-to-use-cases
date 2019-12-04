class UserRegister
  attr_reader :name, :password, :password_confirmation

  def initialize(user_params)
    @name = user_params[:name].try(:squish)
    @password = user_params[:password].try(:strip)
    @password_confirmation = user_params[:password_confirmation].try(:strip)

    @errors = {}
  end

  def register_user
    @errors[:password] = ["can't be blank"] if password.blank?
    @errors[:password_confirmation] = ["can't be blank"] if password_confirmation.blank?

    if password_filled? && password != password_confirmation
      @errors[:password_confirmation] = ["doesn't match password"]
    end

    return OpenStruct.new(errors: @errors, valid?: false) unless @errors.empty?

    token = SecureRandom.uuid
    password_digest = Digest::SHA256.hexdigest(password)

    User
      .new(name: name, password_digest: password_digest, token: token)
      .tap(&:save)
  end

  private

    def password_filled?
      password.present? && password_confirmation.present?
    end
end
