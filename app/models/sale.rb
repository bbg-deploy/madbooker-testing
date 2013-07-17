# == Schema Information
#
# Table name: sales
#
#  id              :integer          not null, primary key
#  inventory_id    :integer
#  booking_id      :integer
#  hotel_id        :integer
#  rate            :decimal(15, 4)
#  discounted_rate :decimal(15, 4)
#  date            :date
#  created_at      :datetime
#  updated_at      :datetime
#

class Sale < ActiveRecord::Base
  belongs_to :inventory, :counter_cache => true
  belongs_to :hotel
  belongs_to :booking
  
  validates_presence_of :inventory_id, :booking_id, :hotel_id, :rate, :discounted_rate, :date
end
