# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

### User Creation
users = [
		{username: "Nikitha Rokhade", email: "nikitha.rokhade@accionlabs.com"}, 
		{username: "Prabu Gnanasekar", email: "prabu.gnanasekar@accionlabs.com"},
    {username: "Madhusudhan V", email: "madhusudhan.v@accionlabs.com"}, 
    {username: "Vinutha Shreyas", email: "vinutha.shreyas@accionlabs.com"}
]

users.each do |user|
  User.create(email: user[:email], username: user[:username], role: 1, password_digest: "test123", active: true)
end

### Location
["JP Nagar", "Whitefield - Gamma", "Whitefield - Delta"].each do |loc|
  location = Location.create(name: loc)
  rand(1..5).times.each_with_index do |i|
  	Room.create(name: "Room #{i + 1}", location_id: location.id)
  end
end

## Meetings
meeting_location = Location.where(name: "JP Nagar").last
User.all.each_with_index do |user, i|
  datetime = DateTime.now + i.day
  meeting_location.rooms.each_with_index do |room, index|
    time = (datetime + index.hour).strftime("%Y-%m-%d %H:00")
    end_time = (datetime + index.hour) + 1.hour
  	meeting = Meeting.create(user_id: user.id, room_id: room.id, start_time: time, end_time: end_time, description: "Description #{index + 1}")
    meeting.attendee_users = User.where.not(id: user.id)
    meeting.save
  end
end