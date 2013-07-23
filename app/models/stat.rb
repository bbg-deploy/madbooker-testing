# == Schema Information
#
# Table name: stats
#
#  id         :integer          not null, primary key
#  hotel_id   :integer
#  start      :date
#  end        :date
#  user_bug   :string(255)
#  type       :string(255)
#  url        :string(255)
#  subdomain  :string(255)
#  data       :text
#  created_at :datetime
#  updated_at :datetime
#

class Stat < ActiveRecord::Base
  
  #page types
  PAGE = "page"
  
  def self.page url: "", hotel: nil, user_bug: "", params: nil
    s = Stat.new
    s.hotel_id = hotel.id
    s.user_bug = user_bug
    s.type = PAGE
    s.url = url
    s.subdomain = hotel.subdomain
    s.data = filter_cc_(params).to_json
    s.save
    s
  end
  
  
  private
  def self.filter_cc_ hash
    hash.each do |k,v|
      if v.is_a? Hash
        filter_cc_ v
      end
    end
    hash.delete_if{|k,v| k.to_s.starts_with? "cc_"}
  end
  
end
