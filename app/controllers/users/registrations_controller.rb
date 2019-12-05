class Users::RegistrationsController < ApplicationController
  def create
    user_params = params.require(:user).permit(:name, :password, :password_confirmation)

    result = RegisterUser.call(user_params: user_params)

    if result.success?
      render_json(201, user: result.user.as_json(only: [:id, :name, :token]))
    else
      render_json(422, user: result.user.errors.as_json)
    end
  rescue ActionController::ParameterMissing => e
    render_json(400, error: e.message)
  end
end
