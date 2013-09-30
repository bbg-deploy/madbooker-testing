# == Schema Information
#
# Table name: bookings
#
#  id                  :integer          not null, primary key
#  hotel_id            :integer
#  customer_id         :integer
#  bookable_id         :integer
#  arrive              :date
#  depart              :date
#  rate                :decimal(15, 4)
#  discounted_rate     :decimal(15, 4)
#  created_at          :datetime
#  updated_at          :datetime
#  first_name          :string(255)
#  last_name           :string(255)
#  made_by_first_name  :string(255)
#  made_by_last_name   :string(255)
#  email               :string(255)
#  email_confirmation  :string(255)
#  sms_confirmation    :string(255)
#  encrypted_cc_number :string(255)
#  cc_month            :integer
#  cc_year             :integer
#  encrypted_cc_cvv    :string(255)
#  cc_zipcode          :string(255)
#  guid                :string(255)
#  state               :string(255)
#  bookable_type       :string(255)
#  paid                :datetime
#  total               :decimal(15, 2)
#


class Booking < ActiveRecord::Base
  include StateScopes
  
  belongs_to :hotel
  belongs_to :bookable, polymorphic: true
  has_many :sales, :dependent => :destroy
  has_many :applied_sales_taxes, :dependent => :destroy
  has_many :inventories, :through => :sales
  
  
  attr_encrypted :cc_number, :key => "3acfbcdebdd42df8c3bbe1cd6d72ec3"
  attr_encrypted :cc_cvv, :key => "a2250c90839d4eb8b7c76cc4a0c06822"
  
  scope :by_last_name, ->{reorder(:last_name)}
  scope :for_date, ->(date){
    if date.nil?
      date = Date.current
    else date.is_a? String
      date = Chronic.parse( date).to_date
    end
    where(arrive: date)
  }
  scope :need_cleanup, ->{ where "arrive < ? and encrypted_cc_number is not null", Date.current - 14 }
  
  
  validates_presence_of :hotel_id, :bookable_id, :bookable_type, :arrive, :depart, 
    :rate, :cc_zipcode, :encrypted_cc_cvv, :cc_year, :cc_month, :encrypted_cc_number,
    :first_name, :last_name, :email
    
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/
  validates_format_of :email_confirmation, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/, allow_blank: true
  
  before_create :create_guid
  after_save :persist_state_to_sales
  
  
  
  def room_type_id
    if bookable.is_a? RoomType
      bookable.id
    else
      bookable.room_type.id
    end
  end
  
  ## 
  # state stuff
  ##
  include SimpleStates
  self.initial_state = :open
  states :open, :checked_in, :canceled, :no_show, :checked_out
  event :open, :to => :open
  event :check_out, :to => :checked_out
  event :check_in, :to => :checked_in
  event :cancel, :to => :canceled
  event :no_show, :to => :no_show
  
  
  private
  
  def create_guid
    self.guid = UUIDTools::UUID.random_create.to_s.gsub("-", "")
  end
  
  def persist_state_to_sales
    return true unless sales.count > 0
    sales.update_all state: state
  end
  
end
