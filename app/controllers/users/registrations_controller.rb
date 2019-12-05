class Users::RegistrationsController < ApplicationController
  def create
    User::Register::Flow
      .call(params: params)
      .on_failure(:parameter_missing) { |error| render_json(400, error: error[:message]) }
      .on_failure(:invalid_user_params) { |user| render_json(422, user: user[:errors]) }
      .on_success { |result| render_json(201, user: result[:user]) }
  end
end
