class Users::RegistrationsController < ApplicationController
  def create
    user_params = params.require(:user).permit(:name, :password, :password_confirmation)

    password = user_params[:password].to_s.strip
    password_confirmation = user_params[:password_confirmation].to_s.strip

    errors = {}
    errors[:password] = ["can't be blank"] if password.blank?
    errors[:password_confirmation] = ["can't be blank"] if password_confirmation.blank?

    if errors.present?
      render_json(422, user: errors)
    else
      if password != password_confirmation
        render_json(422, user: { password_confirmation: ["doesn't match password"] })
      else
        password_digest = Digest::SHA256.hexdigest(password)

        user_data = {
          name: user_params[:name],
          token: SecureRandom.uuid,
          password_digest: password_digest,
        }

        user = User.new(user_data)

        if user.save
          render_json(201, user: user.as_json(only: [:id, :name, :token]))
        else
          render_json(422, user: user.errors.as_json)
        end
      end
    end
  rescue ActionController::ParameterMissing => e
    render_json(400, error: e.message)
  end
end
