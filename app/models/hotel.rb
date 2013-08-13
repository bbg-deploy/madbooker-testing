# == Schema Information
#
# Table name: hotels
#
#  id                                       :integer          not null, primary key
#  owner_id                                 :integer
#  name                                     :string(255)
#  url                                      :string(255)
#  phone                                    :string(255)
#  fax                                      :string(255)
#  room_rates_display                       :string(255)
#  subdomain                                :string(255)
#  street1                                  :string(255)
#  google_analytics_code                    :text
#  fine_print                               :text
#  logo_file_name                           :string(255)
#  logo_content_type                        :string(255)
#  logo_file_size                           :integer
#  logo_updated_at                          :datetime
#  created_at                               :datetime
#  updated_at                               :datetime
#  time_zone                                :string(255)      default("Eastern Time (US & Canada)")
#  minimal_inventory_notification_threshold :integer          default(0)
#  currency_id                              :integer          default(840)
#  street2                                  :string(255)
#  street3                                  :string(255)
#  city                                     :string(255)
#  state                                    :string(255)
#  country                                  :string(255)
#  postal_code                              :string(255)
#  email                                    :string(255)
#

class Hotel < ActiveRecord::Base
  
  belongs_to :owner, :class_name => "User"
  has_many :room_types, :dependent => :destroy
  has_many :inventories, :dependent => :destroy
  has_many :bookings, :dependent => :destroy
  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships
  belongs_to :currency, :dependent => :destroy
  has_many :add_ons, :dependent => :destroy
  has_many :packages, :dependent => :destroy
  has_many :sales, :dependent => :destroy
  has_many :stats, :dependent => :destroy
  
  has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

  ROOM_RATE_DISPLAY = ["Short", "Long"]
  
  accepts_nested_attributes_for :room_types, :allow_destroy => true

  validates_presence_of :name
  validates_presence_of :url
  validates_presence_of :subdomain
  validates_presence_of :email
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/

  
  
  def url
    "#{App.protocol}://#{subdomain}.#{App.domain}/book"
  end

  def host
    "#{subdomain}.#{App.domain}"
  end

end
