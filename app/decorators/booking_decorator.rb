class BookingDecorator < ApplicationDecorator
  delegate_all

  attr_accessor :step
  
  
  def name
    "#{last_name}, #{first_name}"
  end
  
  def lowest_rate
    if discounted_rate
      discounted_rate
    else
      rate
    end
  end
  
  def room_name
    room_type.name
  end
  
  def made_by
    if made_by_first_name.blank? && made_by_last_name.blank?
      name
    else
      "#{made_by_last_name}, #{made_by_first_name}"
    end
  end
  
  def days
    range.to_a.size
  end
  
  def summary
    room = room_type.name
    
    "You've selected a #{room} for #{days} #{"day".pluralize days}, arriving on #{arrive} and departing on #{depart}."
  end
  
  def range
    if arrive.is_a? String
      Date.new(arrive)..Date.new(depart)
    else
      arrive..depart
    end
  end
  
  def url
    booking_url(guid, host: hotel.host, protocol: App.protocol)
  end

end
