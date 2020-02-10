json.set! :meetings do 
  json.array @meetings.each do |meeting|
    json.(meeting, :description, :start_time, :end_time)
    json.set! :organizer do 
      json.(meeting.user, :id, :email, :username)
    end
    json.set! :room do 
      json.(meeting.room, :id, :name)    	
    end
  end
end