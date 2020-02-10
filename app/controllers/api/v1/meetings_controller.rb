class Api::V1::MeetingsController < Api::V1::BaseController
  before_action :set_meetings
 
  def index
  
  end

  private 

  def set_meetings 
    @meetings = Meeting.all
  end

end