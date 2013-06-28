class BookingDecorator < ApplicationDecorator
  delegate_all

  attr_accessor :step
  
  
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
