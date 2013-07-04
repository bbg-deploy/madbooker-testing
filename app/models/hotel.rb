# == Schema Information
#
# Table name: hotels
#
#  id                    :integer          not null, primary key
#  owner_id              :integer
#  name                  :string(255)
#  url                   :string(255)
#  phone                 :string(255)
#  fax                   :string(255)
#  room_rates_display    :string(255)
#  subdomain             :string(255)
#  address               :text
#  google_analytics_code :text
#  fine_print            :text
#  logo_file_name        :string(255)
#  logo_content_type     :string(255)
#  logo_file_size        :integer
#  logo_updated_at       :datetime
#  created_at            :datetime
#  updated_at            :datetime
#

class Hotel < ActiveRecord::Base
  
  belongs_to :owner, :class_name => "User"
  has_many :room_types
  has_many :inventories
  has_many :bookings
  has_many :memberships
  has_many :users, :through => :memberships
  
  has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

  ROOM_RATE_DISPLAY = ["Short", "Long"]
  
  accepts_nested_attributes_for :room_types, :allow_destroy => true

  validates_presence_of :name
  validates_presence_of :url
  validates_presence_of :subdomain
  
  
  def url
    "#{App.protocol}://#{subdomain}.#{App.domain}/book"
  end

  def host
    "#{subdomain}.#{App.domain}"
  end

end
