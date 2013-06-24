# == Schema Information
#
# Table name: bookings
#
#  id                 :integer          not null, primary key
#  hotel_id           :integer
#  customer_id        :integer
#  room_type_id       :integer
#  inventory_id       :integer
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
#

class Booking < ActiveRecord::Base
  belongs_to :hotel
  belongs_to :room_type
  belongs_to :inventory
  
  
end
