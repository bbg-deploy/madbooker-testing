class Booking::Reserve < Less::Interaction
  
  expects :context
  
  def run
    # res = Less::Response.new 400, available_rooms
    # if res.object.blank?
    #   res.status = 400
    # else
    #   res.status = 200
    # end
    # res
    
    inventory
    setup_booking_for_inventory
    save
    return
  end
  
  private
  
  def response
    @response ||= Less::Response.new 400, {booking: booking, error: nil}
  end
  
  def booking
    @booking ||= context.hotel.bookings.new context.params[:booking]
  end
  
  def inventory
    return @inventory if @inventory
    res = Booking::RoomFinder.new(context: context).run
    if res.error? || res.object.select{|i| i.room_type_id == booking.room_type_id}.blank?
      response.status = 400
      response.object[:error] = "Date's not available"
      return
    end
    
    @inventory = res.object.select{|i| i.room_type_id == booking.room_type_id}
  end
  
  def setup_booking_for_inventory
    booking.rate = inventory.rate
    booking.discounted_rate = inventory.discounted_rate
  end
  
    
end