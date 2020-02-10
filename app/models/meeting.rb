class Meeting < ApplicationRecord
  
  belongs_to :user
  belongs_to :room

  has_many :attendees, dependent: :destroy

end
