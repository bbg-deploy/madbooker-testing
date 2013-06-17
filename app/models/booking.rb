# == Schema Information
#
# Table name: bookings
#
#  id              :integer          not null, primary key
#  hotel_id        :integer
#  customer_id     :integer
#  room_type_id    :integer
#  inventory_id    :integer
#  arrive          :date
#  depart          :date
#  rate            :decimal(15, 4)
#  discounted_rate :decimal(15, 4)
#  created_at      :datetime
#  updated_at      :datetime
#

class Booking < ActiveRecord::Base
  belongs_to :hotel
  belongs_to :room_type
  belongs_to :inventory
  
  
end
