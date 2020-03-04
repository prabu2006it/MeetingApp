json.set! :meetings do 
  json.array @meetings.each do |meeting|
    json.(meeting, :description, :start_time, :end_time)
    json.set! :organizer do 
      json.(meeting.user, :id, :email, :username) if meeting.user.present?
    end
    json.set! :room do 
      json.(meeting.room, :id, :name)    	 
    end
    json.set! :attendees do 
      json.array meeting.attendee_users do |user|
      	json.(user, :id, :email, :username)
      end
    end
  end
end