# == Schema Information
#
# Table name: stats
#
#  id          :integer          not null, primary key
#  hotel_id    :integer
#  start       :date
#  end         :date
#  user_bug    :string(255)
#  kind        :string(255)
#  url         :string(255)
#  subdomain   :string(255)
#  data        :text
#  created_at  :datetime
#  updated_at  :datetime
#  device_type :string(255)
#

class Stat < ActiveRecord::Base
  
  belongs_to :hotel
  
  #page types
  PAGE          = "page"
  SEARCH        = "search"
  LOOK          = "look"
  BOOK          = "book"
  USER          = "user"
  SUBSCRIPTION  = "subscription"
  FUNNEL        = "funnel"
  
  #device_types
  MOBILE        = "mobile"
  TABLET        = "tablet"
  DESKTOP       = "desktop"
  TV            = "tv"
  DEVICE_TYPES  = [MOBILE, TABLET, DESKTOP] #tv ignored for now
  
  
  
  FUNNEL_STEPS = {
    booked: "Booked", 
    attempt: "Attempt to book", 
    choose_room: "Choose room", 
    choose_dates: "Choose dates", 
    start: "Start"
  }

  
  scope :mobile,        ->{where device_type: MOBILE}
  scope :tablet,        ->{where device_type: TABLET}
  scope :desktop,       ->{where device_type: DESKTOP}
  scope :searches,      ->{where kind: SEARCH}
  scope :pages,         ->{where kind: PAGE}
  scope :funnels,       ->{where kind: FUNNEL}
  scope :look_to_book,  ->{where kind: [LOOK, BOOK]}
  scope :denials,       ->{ where( kind: SEARCH).where('data like \'%"available_rooms":[]%\'') }
  scope :range,         ->(range) { where created_at: range }
  scope :searched_for,   ->(range) { where "? between start and end or ? between start and end", range.first, range.last }
  
  
  
  def self.page url: "", context: context
    s = setup context: context, type: PAGE
    s.url = url
    s.data = filter_cc_(context.params).to_json
    s.save
    s
  end
    
  def self.funnel step: "", context: context
    s = setup context: context, type: FUNNEL
    s.url = step
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
  
  def self.new_user context: context
    s = new
    s.kind = USER
    s.data = {user: context.user.id, payment_status: context.user.payment_status}
    s.save
    s
  end
  
  def self.subscription user: user
    s = new
    s.kind = SUBSCRIPTION
    s.data = {user: user.id, status: user.payment_status}
    s.save
    s
  end
  
  private
  
  def self.setup context: context, type: type
    s = Stat.new
    s.hotel_id = context.hotel.id
    s.user_bug = context.user_bug
    s.kind = type
    s.device_type = context.device_type || "unknown"
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
