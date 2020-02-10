class Room < ApplicationRecord

  has_many :meetings, dependent: :destroy
  belongs_to :location

end
