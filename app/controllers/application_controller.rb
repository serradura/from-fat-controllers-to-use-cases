class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  protected

    def authenticate_user
      head :forbidden unless current_user
    end

    def current_user
      @current_user ||= authenticate_or_request_with_http_token do |token|
        User.find_by(token: token)
      end
    end

    def render_json(status, json = {})
      render status: status, json: json
    end
end
