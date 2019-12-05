class RegisterUser
  include Interactor

  def call
    user_params = context.user_params

    name = user_params[:name].try(:squish)
    password = user_params[:password].try(:strip)
    password_confirmation = user_params[:password_confirmation].try(:strip)

    @errors = {}

    @errors[:password] = ["can't be blank"] if password.blank?
    @errors[:password_confirmation] = ["can't be blank"] if password_confirmation.blank?

    if password_filled?(password, password_confirmation) && password != password_confirmation
      @errors[:password_confirmation] = ["doesn't match password"]
    end

    context.fail!(user: OpenStruct.new(errors: @errors)) if @errors.present?

    context.user = user = create_user(name, password)

    context.fail! if user.invalid?
  end

  private

    def password_filled?(password, password_confirmation)
      password.present? && password_confirmation.present?
    end

    def create_user(name, password)
      token = SecureRandom.uuid
      password_digest = Digest::SHA256.hexdigest(password)

      User
        .new(name: name, password_digest: password_digest, token: token)
        .tap(&:save)
    end
end
