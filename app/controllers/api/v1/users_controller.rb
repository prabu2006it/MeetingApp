class Api::V1::UsersController < Api::V1::BaseController
  before_action :doorkeeper_authorize!, only: [:destroy]

  def signin
    if authorize_application
      user = User.where(email: user_params[:email]).last
      if user.present? && user.authenticate(user_params[:password]).present?
        access_token = user.get_access_token(@app)
        render json: {success: true, token: access_token.token }
      elsif user.blank?
        not_found
      else
        not_authorized
      end
    else
      render json: {success: false, error: 'App does not exist'}, status: 404
    end
  end

  def signout
    if current_user.present?
      access_token = Doorkeeper::AccessToken.where(resource_owner_id: current_user.id, token: params[:access_token]).last
      status = access_token.present? ? access_token.try(:revoke) : false
      Doorkeeper::AccessToken.where(resource_owner_id: current_user.id).destroy_all
    end
    if status
      render json: {success: true, message: "User Logged out successfully." }      
    else
      not_authorized
    end
  end

  private

  def not_found
    render json: { success: false, message: 'Email Does not Exist.' }
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
