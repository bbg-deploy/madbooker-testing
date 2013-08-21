class BookingDecorator < ApplicationDecorator
  delegate_all
  
  decorates_association :bookable

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
    bookable.name
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
    room = bookable.name
    
    "You've selected a #{room} for #{days} #{"day".pluralize days}, arriving on #{h.format arrive} and departing on #{h.format depart}. The price per night is #{h.format lowest_rate} and the total price is #{h.format lowest_rate * days}".html_safe
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
