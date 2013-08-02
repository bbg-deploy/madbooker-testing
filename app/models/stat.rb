# == Schema Information
#
# Table name: stats
#
#  id         :integer          not null, primary key
#  hotel_id   :integer
#  start      :date
#  end        :date
#  user_bug   :string(255)
#  kind       :string(255)
#  url        :string(255)
#  subdomain  :string(255)
#  data       :text
#  created_at :datetime
#  updated_at :datetime
#  mobile     :boolean          default(FALSE)
#

class Stat < ActiveRecord::Base
  
  belongs_to :hotel
  
  #page types
  PAGE   = "page"
  SEARCH = "search"
  LOOK   = "look"
  BOOK   = "book"

  
  scope :searches,      ->{where kind: SEARCH}
  scope :pages,          ->{where kind: PAGE}
  scope :look_to_book,  ->{where kind: [LOOK, BOOK]}
  scope :range,         ->(range){ where created_at: range }
  
  
  
  def self.page url: "", context: context
    s = setup context: context, type: PAGE
    s.url = url
    s.data = filter_cc_(context.params).to_json
    s.save
    s
  end
  
  def self.search context: context, available_rooms: available_rooms, dates: range
    s = setup context: context, type: SEARCH
    s.data = {available_rooms: available_rooms}.to_json
    s.start = dates.first
    s.end = dates.last
    s.save
    s
  end
  
  def self.look context: context
    s = setup context: context, type: LOOK
    s.save
    s
  end
  
  def self.book context: context
    s = setup context: context, type: BOOK
    s.save
    s
  end
  
  
  private
  
  def self.setup context: context, type: type
    s = Stat.new
    s.hotel_id = context.hotel.id
    s.user_bug = context.user_bug
    s.kind = type
    s.mobile = context.mobile || false
    s.subdomain = context.hotel.subdomain
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