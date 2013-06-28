# == Schema Information
#
# Table name: bookings
#
#  id                 :integer          not null, primary key
#  hotel_id           :integer
#  customer_id        :integer
#  room_type_id       :integer
#  arrive             :date
#  depart             :date
#  rate               :decimal(15, 4)
#  discounted_rate    :decimal(15, 4)
#  created_at         :datetime
#  updated_at         :datetime
#  first_name         :string(255)
#  last_name          :string(255)
#  made_by_first_name :string(255)
#  made_by_last_name  :string(255)
#  email              :string(255)
#  email_confirmation :string(255)
#  sms_confirmation   :string(255)
#  cc_number          :string(255)
#  cc_month           :integer
#  cc_year            :integer
#  cc_cvv             :string(255)
#  cc_zipcode         :string(255)
#  guid               :string(255)
#


class Booking < ActiveRecord::Base
  
  belongs_to :hotel
  belongs_to :room_type
  has_many :sales, :dependent => :destroy
  has_many :inventories, :through => :sales
  
  
  validates_presence_of :hotel_id, :room_type_id, :arrive, :depart, 
    :rate, :cc_zipcode, :cc_cvv, :cc_year, :cc_month, :cc_number,
    :first_name, :last_name, :email
    
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/
  validates_format_of :email_confirmation, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/, allow_blank: true
  
  before_create :create_guid
  
  
  private
  
  def create_guid
    self.guid = UUIDTools::UUID.random_create.to_s.gsub("-", "")
  end
  
end
