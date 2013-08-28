# == Schema Information
#
# Table name: memberships
#
#  id         :integer          not null, primary key
#  hotel_id   :integer
#  user_id    :integer
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  guid       :string(255)
#

class Membership < ActiveRecord::Base
  belongs_to :hotel
  belongs_to :user
  
  validates_presence_of :hotel_id
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/
  
end
