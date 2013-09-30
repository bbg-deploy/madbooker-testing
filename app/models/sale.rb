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
#  price           :decimal(15, 4)
#  state           :string(255)
#  device_type     :string(255)
#  total           :decimal(15, 2)
#

class Sale < ActiveRecord::Base
  include StateScopes


  belongs_to :inventory, :counter_cache => true
  belongs_to :hotel
  belongs_to :booking
  
  validates_presence_of :inventory_id, :booking_id, :hotel_id, :rate, :date, :price
  
  scope :range, ->(range){ where date: range }
  scope :paid, ->{ joins(:booking).where("paid is not null") }
  
  
end
