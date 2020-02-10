class Location < ApplicationRecord
  has_many :rooms, dependent: :destroy
end
