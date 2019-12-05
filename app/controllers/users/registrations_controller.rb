class Users::RegistrationsController < ApplicationController
  def create
    user_params = User::Params.to_register(params)

    user = User::Registration.new(user_params).create

    if user.persisted?
      render_json(201, user: user.as_json(only: [:id, :name, :token]))
    else
      render_json(422, user: user.errors.as_json)
    end
  rescue ActionController::ParameterMissing => e
    render_json(400, error: e.message)
  end
end
