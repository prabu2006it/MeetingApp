class Api::V1::BaseController < ActionController::Base
  skip_before_action :verify_authenticity_token

  private 

  def current_token
    token = @access_token.try(:token) || params[:access_token]
    Doorkeeper::AccessToken.find_by(token: token)
  end

  def current_user
    User.find(current_token.resource_owner_id) unless current_token.nil?
  end

  def authorize_application
    @app = Doorkeeper::Application.first
    return @app.present? ? true : false
  end

  def not_authorized
    render json: {success: false, error: 'Not authorized' }, status: :unauthorized
  end

  def render_error(resource, status)
    render json: resource.errors, status: status
  end
end