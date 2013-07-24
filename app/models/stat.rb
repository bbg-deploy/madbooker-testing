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
  
  belongs_to :hotel
  
  #page types
  PAGE = "page"
  SEARCH = "search"
  
  scope :searches, ->{where type: SEARCH}
  scope :range, ->(range){ where created_at: range }
  
  
  
  def self.page url: "", hotel: nil, user_bug: "", params: nil
    s = setup hotel: hotel, user_bug: user_bug, type: PAGE
    s.url = url
    s.data = filter_cc_(params).to_json
    s.save
    s
  end
  
  def self.search hotel: hotel, user_bug: user_bug, available_rooms: available_rooms, dates: range
    s = setup hotel: hotel, user_bug: user_bug, type: SEARCH
    s.data = {available_rooms: available_rooms}.to_json
    s.start = dates.first
    s.end = dates.last
    s.save
    s
  end
  
  
  private
  
  def self.setup user_bug: user_bug, hotel: nil, type: type
    s = Stat.new
    s.hotel_id = hotel.id
    s.user_bug = user_bug
    s.type = type
    s.subdomain = hotel.subdomain
    s
  end
  
  def self.filter_cc_ hash
    hash.each do |k,v|
      if v.is_a? Hash
        filter_cc_ v
      end
    end
    hash.delete_if{|k,v| k.to_s.starts_with? "cc_"}
  end
  
end
