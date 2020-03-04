class Api::V1::MeetingsController < Api::V1::BaseController
  before_action :set_meetings
  before_action :check_current_user, only: [:create]
  before_action :parse_params, only: [:create, :update]
  before_action :set_meeting, only: [:update, :destroy]

  def index
  
  end

  def create
    meeting = current_user.meetings.new(meeting_params)
    if meeting.save
      render json: {success: true, message: "Meeting created sucessfully."}
    else
      render_error(meeting,:ok)
    end
  end

  def update
    if @meeting.update_attributes(meeting_params)
      render json: {success: true, message: "Meeting updated sucessfully."}
    else
      render_error(@meeting,:ok)      
    end
  end

  def destroy
    if @meeting.user == current_user
      @meeting.destroy
      render json: {success: true, message: "Meeting deleted sucessfully"}
    else  
      render json: {success: false, message: "Can delete only meetings created by you."}
    end
  end

  def dropdown_values
    
  end

  private 

  def set_meetings 
  	@meetings =  Meeting.search(params[:search])
  end

  def set_meeting
    @meeting = @meetings.where(id: params[:id]).last
  end

  def meeting_params
    params.require(:meeting).permit(:description, :room_id, :start_time, :end_time, attendees_attributes: [:id, :user_id, :_destroy])
  end

  def user_params
    params.require(:users).permit(attendees: [:id, :role, :emp_id, :first_name, :last_name, :project, :email, :department])
  end

  def parse_params
    attendees = []
    if user_params[:attendees].present?
      user_params[:attendees].each do |user_param|
        if user_param["id"].blank?
          user = User.where(emp_id: user_param[:emp_id]).last
          if user.blank?
            user = User.create(user_param)
          end
          attendees << {user_id: user.id} if user.valid?
        else
          attendees << user_param
        end
        params[:meeting].merge!({attendees_attributes: attendees})
      end
    end
  end
end
