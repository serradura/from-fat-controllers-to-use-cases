class User::Registration
  attr_reader :name, :password, :password_confirmation

  def initialize(params)
    @name = params[:name].try(:squish)
    @password = User::Password.new(params[:password])
    @password_confirmation = User::Password.new(params[:password_confirmation])
  end

  def create
    password_validation = User::Password::Validation.new(password, password_confirmation)

    return create_user unless password_validation.errors?

    OpenStruct.new(persisted?: false, errors: password_validation.errors)
  end

  private

    def create_user
      attributes =
        { name: name, password_digest: password.digest, token: SecureRandom.uuid }

      User.new(attributes).tap(&:save)
    end
end
