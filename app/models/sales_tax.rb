# == Schema Information
#
# Table name: sales_taxes
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  calculated_by  :string(255)
#  calculated_how :string(255)
#  amount         :decimal(15, 2)
#  hotel_id       :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class SalesTax < ActiveRecord::Base
  
  belongs_to :hotel
  
  validates_presence_of :name, :calculated_by, :calculated_how, :amount, :hotel_id
  
  PER_NIGHT = "Per night"
  PER_STAY = "Per stay"
  CALCULATED_BY = [PER_NIGHT, PER_STAY]
  
  PERCENTAGE = "Percentage"
  FIXED_AMOUNT = "Fixed amount"
  CALCULATED_HOW = [PERCENTAGE, FIXED_AMOUNT]
end
