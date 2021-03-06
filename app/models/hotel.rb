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
#  google_analytics_code                    :string(255)
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
#  gauth_access_token                       :string(255)
#  gauth_refresh_token                      :string(255)
#  gauth_expires_in                         :integer
#  gauth_issued_at                          :datetime
#  ga_account_id                            :string(255)
#  ga_profile_id                            :string(255)
#  google_analytics_code_type               :string(255)      default("Universal Analytics")
#

class Hotel < ActiveRecord::Base
  
  belongs_to :owner, :class_name => "User"
  has_many :room_types, :dependent => :destroy
  has_many :inventories, :dependent => :destroy
  has_many :bookings, :dependent => :destroy
  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships
  belongs_to :currency
  has_many :add_ons, :dependent => :destroy
  has_many :packages, :dependent => :destroy
  has_many :sales, :dependent => :destroy
  has_many :stats, :dependent => :destroy
  has_many :sales_taxes, :dependent => :destroy
  
  has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

  ROOM_RATE_DISPLAY = ["Short", "Long"]
  GA_UNIVERSAL_ANALYTICS = "Universal Analytics"
  GA_CLASSIC_ASYNCHRONOUS = "Classic Asynchronous"
  GOOGLE_ANALYTICS_TYPES = [GA_UNIVERSAL_ANALYTICS, GA_CLASSIC_ASYNCHRONOUS]
  
  accepts_nested_attributes_for :room_types, :allow_destroy => true
  
  validates_presence_of :name
  validates_presence_of :url
  validates_presence_of :subdomain
  validates_presence_of :email
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/
  validates_format_of :url, with: /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix
  
  validates_uniqueness_of :subdomain, :url

  def public_email_address
    "#{name} <reservations@madbooker.com>"
  end
  
  def booking_url
    "#{App.protocol}://#{subdomain}.#{App.domain.gsub("app.", "")}/book"
  end

  def host
    "#{subdomain}.#{App.domain.gsub("app.", "")}"
  end
  
  def remove_google
    update_attributes :gauth_access_token => nil, 
      :gauth_refresh_token => nil, 
      :gauth_expires_in =>nil, 
      :gauth_issued_at => nil,
      :gauth_access_token  => nil,
      :ga_profile_id => nil,
      :ga_account_id => nil
  end

end
