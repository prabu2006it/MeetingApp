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

end
