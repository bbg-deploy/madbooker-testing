# == Schema Information
#
# Table name: packages
#
#  id               :integer          not null, primary key
#  hotel_id         :integer
#  room_type_id     :integer
#  additional_price :decimal(15, 4)
#  created_at       :datetime
#  updated_at       :datetime
#  active           :boolean          default(TRUE)
#

class Package < ActiveRecord::Base
  
  belongs_to :hotel
  belongs_to :room_type
  has_many :bundles
  has_many :add_ons, :through => :bundles
  
  validates_presence_of :hotel_id, :room_type_id, :rate
  
  scope :active, ->{where active: true}
  scope :inactive, ->{where active: false}
end
