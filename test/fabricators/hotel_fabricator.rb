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

Fabricator(:hotel) do
  name                  
  url                   
  phone                 
  fax                   
  room_rates_display    
  subdomain             
  address               
  google_analytics_code 
  fine_print            
  logo_file_name        
  logo_content_type     
  logo_file_size        
  logo_updated_at       
end
