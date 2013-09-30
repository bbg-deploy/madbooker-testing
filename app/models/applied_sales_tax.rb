# == Schema Information
#
# Table name: applied_sales_taxes
#
#  id             :integer          not null, primary key
#  booking_id     :integer
#  sales_tax_id   :integer
#  quantity       :integer
#  name           :string(255)
#  calculated_by  :string(255)
#  calculated_how :string(255)
#  amount         :decimal(15, 2)
#  total          :decimal(15, 2)
#  created_at     :datetime
#  updated_at     :datetime
#

class AppliedSalesTax < ActiveRecord::Base
  
  belongs_to :booking
  belongs_to :sales_tax
  
end
