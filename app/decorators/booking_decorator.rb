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
  
  def nights
    range.to_a.size - 1
  end
  
  def paid_status
    if paid?
      "Paid"
    else
      "Unpaid"
    end
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
