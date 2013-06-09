# == Schema Information
#
# Table name: hotels
#
#  id                    :integer          not null, primary key
#  user_id               :integer
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
  
  belongs_to :user
  
  has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"


  validates_presence_of :name
  validates_presence_of :url
  validates_presence_of :subdomain
  
  
  def url
    "http://#{subdomain}.#{App.domain}"
  end
  

end
