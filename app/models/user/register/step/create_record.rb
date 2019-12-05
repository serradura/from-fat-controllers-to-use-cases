class User::Register::Step::CreateRecord < Micro::Case
  attributes :name, :password, :password_confirmation

  def call!
    user = User.new(user_attributes).tap(&:save)

    return Success { { user: user } } if user.persisted?

    Failure(:invalid_user_params) { { errors: user.errors.as_json } }
  end

  private

    def user_attributes
      { name: name, password_digest: password.digest, token: SecureRandom.uuid }
    end
end
