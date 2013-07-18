# == Schema Information
#
# Table name: room_types
#
#  id              :integer          not null, primary key
#  hotel_id        :integer
#  number_of_rooms :integer
#  name            :string(255)
#  default_rate    :decimal(15, 4)
#  discounted_rate :decimal(15, 4)
#  description     :text
#  created_at      :datetime
#  updated_at      :datetime
#

class RoomType < ActiveRecord::Base
  belongs_to :hotel
  has_many :inventories
  has_many :bookings, as: :bookable
  has_many :packages
  
  
  validates_presence_of :name, :number_of_rooms, :default_rate
end
