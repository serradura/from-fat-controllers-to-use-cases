class User::Register::Step::NormalizeParams < Micro::Case
  attribute :params

  validates! :params, type: ActionController::Parameters

  def call!
    user_params = User::Params.to_register(params)

    Success do
      {
        name: user_params[:name].try(:squish),
        password: User::Password.new(user_params[:password]),
        password_confirmation: User::Password.new(user_params[:password_confirmation])
      }
    end
  rescue ActionController::ParameterMissing => e
    Failure(:parameter_missing) { { message: e.message } }
  end
end
