# == Schema Information
#
# Table name: add_ons
#
#  id          :integer          not null, primary key
#  hotel_id    :integer
#  name        :string(255)
#  description :text
#  price       :decimal(15, 4)
#  created_at  :datetime
#  updated_at  :datetime
#  active      :boolean          default(TRUE)
#

class AddOn < ActiveRecord::Base
  
  belongs_to :hotel
  has_many :bundles
  has_many :packages, :through => :bundles
  
  validates_presence_of :name, :price, :hotel_id
end
