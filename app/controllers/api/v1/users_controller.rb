class Api::V1::UsersController < Api::V1::BaseController

  def auth_login
    jwt_user = User.where(current_token: params[:jwt]).last
    user = User.where(emp_id: user_params[:emp_id]).last
    if jwt_user.present? || user.present?
      user.attributes = user_params
    else
      user = User.new(user_params)
    end
    user.current_token = params[:jwt]
    if user.save  
      render json: {success: true}
    else
      not_found
    end
  end

  def signout
    if current_user.present?
      status = current_user.update_column("current_token", nil)
    end
    if status
      render json: {success: true, message: "User Logged out successfully." }      
    else
      not_authorized
    end
  end

  private

  def not_found
    render json: { success: false, message: 'User Does not Exist.' }
  end

  def user_params
    params.require(:user).permit(:email, :department, :role, :emp_id, :first_name, :last_name, :project)
  end
end