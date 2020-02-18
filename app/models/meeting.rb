class Meeting < ApplicationRecord
  
  belongs_to :user
  belongs_to :room

  has_many :attendees, dependent: :destroy
  has_many :attendee_users, through: :attendees, source: :user

  validates_presence_of :description, :start_time, :end_time

  ransacker :by_room_id, formatter: proc { |room_id|
    meetings = Meeting.where(room_id: room_id)
    meetings = meetings.present? ? meetings.pluck(:id) : nil
    }, splat_param: true do |parent|
      parent.table[:id]
  end

  #{description: "desc", meeting_time: "2020-02-09T14:27:42,2020-02-12T14:27:42", room_id: 1}
  def self.search(parameters = {})
    full_text_search = ["description"]
    range_match = ["meeting_time"]
    query = {}
    (parameters||{}).reject{|k,v| v.blank?}.each do |k,v|
      if full_text_search.include?(k.to_s)
        query["#{k}_cont".to_sym] = v
      elsif range_match.include?(k.to_s)
        v = v.split(",")
        query["start_time_gteq".to_sym] = v[0]
        query["end_time_lteq".to_sym] = v[1]
      else
        query["by_#{k}_in".to_sym] = v
      end
    end
    ransack(query).result(distinct: true)
  end

  def self.get_slots(slot_size, date, start_time, end_time)
    slots = []

    slots.concat get_day_slots(slot_size, date, start_time, end_time)
    byebug

    slots.each do |s|
      self..each do |meeting|
        if meeting.start_date < s.end_time and meeting.end_date > s.start_time
          s.user_id = meeting.user_id
          s.booked = true
        end
      end
    end
    
    slots
  end

  private 

  def self.get_day_slots(slot_size, date, start_time, end_time)
    slots = []
    slot_count = ((end_time - start_time) / (slot_size * 60)).to_i
    byebug
    slot_count.times do |i|
      slot_start_time = start_time + (i * slot_size).minutes
      slot_start_time = DateTime.new(date.year, date.month, date.day, slot_start_time.hour, slot_start_time.min, slot_start_time.sec)
      slot_end_time = slot_start_time + slot_size.minutes
      slots << {day: date.day, start_time: slot_start_time, end_time: slot_end_time, booked: false}
    end
    slots
  end
end
