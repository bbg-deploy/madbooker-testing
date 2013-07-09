class Booking::Reserve < Less::Interaction
  
  attr_accessor :error
  
  expects :context
  
  def run
    @error = ""
    inventory
    inventories
    return response unless @error.blank?
    return response unless setup_booking_and_save
    send_confirmations
    response
  end
  
  
  def booking
    par = context.params[:booking].permit :arrive, :depart, :room_type_id, :first_name, :last_name, :made_by_first_name,
      :made_by_last_name, :email_confirmation, :email, :sms_confirmation, :cc_zipcode, :cc_cvv, :cc_year, 
      :cc_month, :cc_number
    @booking ||= context.hotel.bookings.new par
  end
  
  private
  
  def response
    @response ||= Less::Response.new 400, self
  end
  
  def room_finder
    @room_finder ||= Booking::RoomFinder.new(context: context).run  
  end
  
  def inventory
    return @inventory if @inventory
    i = room_finder.available_rooms.select{|i| i.room_type_id == booking.room_type_id} 
    if i.blank?
      response.status = 400
      @error = "Date's not available"
      return
    end
    @inventory = i.first
  end
  
  def inventories
    return @inventories if @inventories
    @inventories = room_finder.all_rooms[booking.room_type_id]
  end
  
  def setup_booking_and_save
    booking.rate = inventory.rate
    booking.discounted_rate = inventory.discounted_rate
    Booking.transaction do
      begin
        booking.save!
        @inventories.each do |i|
          booking.sales.create!( inventory_id: i.id, hotel_id: context.hotel.id, rate: i.rate, discounted_rate: i.discounted_rate, date: i.date)
        end
      rescue ActiveRecord::RecordInvalid=>e
        response.status = 500
        @error = e.to_s
        return false
      end
    end
    response.status = 200
    true
  end
  
  def send_confirmations
    send_email_confirmation unless booking.email_confirmation.blank?
    send_sms_confirmation unless booking.sms_confirmation.blank?
  end
  
  def send_email_confirmation
    BookingMailer.confirmation(booking.decorate).deliver
  end
  
  def send_sms_confirmation
    b = booking.decorate
    Sms.deliver booking.sms_confirmation, "Reservation complete! #{b.days} night(s) starting on #{b.arrive}. Details: #{b.url}"
  end
  
    
end