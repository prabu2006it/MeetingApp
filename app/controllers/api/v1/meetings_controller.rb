class Api::V1::MeetingsController < Api::V1::BaseController
  before_action :set_meetings
  before_action :doorkeeper_authorize!, only: [:create]

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

  private 

  def set_meetings 
  	@meetings =  Meeting.search(params[:search])
  end

  def meeting_params
    params.require(:meeting).permit(:description, :room_id, :start_time, :end_time, attendees: [:user_id])
  end
end
