# == Schema Information
#
# Table name: inventories
#
#  id              :integer          not null, primary key
#  hotel_id        :integer
#  room_type_id    :integer
#  available_rooms :integer
#  rate            :decimal(15, 4)
#  discounted_rate :decimal(15, 4)
#  date            :date
#  created_at      :datetime
#  updated_at      :datetime
#  sales_count     :integer          default(0)
#

class Inventory < ActiveRecord::Base
  belongs_to :hotel
  belongs_to :room_type
  has_many :sales
  has_many :bookings, :through => :sales

  validates_presence_of :hotel_id, :room_type_id, :available_rooms, :date, :rate
  
  scope :for_month, ->(date){where date: date.change(day:1)..date.end_of_month}
  scope :range, ->(range) { where date: range }
  scope :for_date, ->(date) { where date: date }
  scope :next_30_days, -> { where date: Date.current..(Date.current+30)}
  scope :with_availablity, ->{where("available_rooms - sales_count > 0")}
  scope :past_threshold, ->(threshold){ where " available_rooms - sales_count <= ?", threshold }
  
  
  
  
end
