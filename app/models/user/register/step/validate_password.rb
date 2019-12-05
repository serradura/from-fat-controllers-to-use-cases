class User::Register::Step::ValidatePassword < Micro::Case
  attributes :password, :password_confirmation

  def call!
    password_validation =
        User::Password::Validation.new(password, password_confirmation)

    return Success { attributes } unless password_validation.errors?

    Failure(:invalid_user_params) { { errors: password_validation.errors } }
  end
end
