class ApplicationController < ActionController::API
  # protect_from_forgery with: :exception

	def authenticated_user!
    auth_header = request.headers["HTTP_AUTHORIZATION"]

    if auth_header.present?
      token = auth_header.split(" ").last
      device_detail = DeviceDetail.find_by(authentication_token: token)

      if device_detail.present?
        @current_user = device_detail.user
      else
        render json: { errors: "Token is invalid" }, status: :ok
      end
    else
      render json: { errors: "Authentication token required" }, status: :ok
    end
  end
end