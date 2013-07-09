# == Schema Information
#
# Table name: bundles
#
#  id         :integer          not null, primary key
#  package_id :integer
#  add_on_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Bundle < ActiveRecord::Base
  
  belongs_to :package
  belongs_to :add_on
  
  validates_presence_of :package_id, :add_on_id
end
