# == Schema Information
#
# Table name: inventories
#
#  id              :integer          not null, primary key
#  hotel_id        :integer
#  room_type_id    :integer
#  available_rooms :integer
#  bookings_count  :integer
#  rate            :decimal(15, 4)   default(0.0)
#  discounted_rate :decimal(15, 4)
#  date            :date
#  created_at      :datetime
#  updated_at      :datetime
#

class Inventory < ActiveRecord::Base
  belongs_to :hotel
  belongs_to :room_type
  
  scope :for_month, ->(date){where date: date.change(day:1)..date.to_time.end_of_month}
  scope :for_range, ->(range) { where date: range }
  
  
  validates_presence_of :hotel_id, :room_type_id, :available_rooms, :date, :rate
  
  
end
