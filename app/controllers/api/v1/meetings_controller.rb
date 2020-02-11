class Api::V1::MeetingsController < Api::V1::BaseController
  before_action :set_meetings
 
  def index
  
  end

  def create
  	Meeting.create()

  end

  private 

  def set_meetings 
  	@meetings =  Meeting.search(params[:search])
  end

end