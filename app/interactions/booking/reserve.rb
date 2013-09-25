class Booking::Reserve < Less::Interaction
  include Booking::Params
  
  attr_accessor :error
  
  DATES_NOT_AVAILABLE = 499
  
  expects :context
  
  def run
    @error = ""
    # inventory
    # inventories
    return response unless check_availablity
    return response unless setup_booking_and_save
    send_confirmations
    response
  end
  
  
  def booking
    @booking ||= Booking::Build.new(Context.new(hotel: context.hotel, params: Booking::ParamsWithRate.new(context).run)).run
  end
  
  private
  
  def check_availablity
    if booking.rate #not nil
      return true
    end
    @error = "Date's not available"
    false
  end
  
  def response
    @response ||= Less::Response.new 400, self
  end
  
  def room_finder
    @room_finder ||= Booking::RoomFinder.new(context: context).run  
  end
  # 
  # def inventory
  #   return @inventory if @inventory
  #   i = room_finder.available_rooms.select{|i| i.room_type_id == booking.room_type_id} 
  #   if i.blank?
  #     response.status = DATES_NOT_AVAILABLE
  #     @error = "Date's not available"
  #     return
  #   end
  #   @inventory = i.first
  # end
  
  def inventories
    return @inventories if @inventories
    @inventories = room_finder.all_rooms[booking.room_type_id]
  end
  
  def setup_booking_and_save
    Booking.transaction do
      begin
        save_bookings
        create_sales
      rescue ActiveRecord::RecordInvalid=>e
        response.status = 500
        @error = e.to_s
        booking.errors.add :base, e.to_s
        return false
      end
    end
    response.status = 200
    true
  end
  
  def save_bookings
    @error = "Can not reserve booking, can't calculate total" and return unless booking.total #this should never happen, but just in case
    booking.save!
  end
  
  
  def create_sales
    inventories.each do |i|
      price = i.discounted_rate.nil? ? i.rate : i.discounted_rate
      booking.sales.create!( inventory_id: i.id, hotel_id: context.hotel.id, rate: i.rate, discounted_rate: i.discounted_rate, date: i.date, price: price, device_type: context.device_type, total: booking.total/booking.nights, state: booking.state)
    end
  end
  
  def send_confirmations
    send_hotel_confirmation
    send_email_confirmation
    send_sms_confirmation unless booking.sms_confirmation.blank?
  end
  
  def send_hotel_confirmation
    BookingMailer.hotel_confirmation(booking.decorate).deliver
  end
  
  def send_email_confirmation
    BookingMailer.confirmation(booking.decorate).deliver
  end
  
  def send_sms_confirmation
    b = booking.decorate
    Sms.deliver booking.sms_confirmation, "Reservation complete! #{b.nights} night(s) starting on #{b.arrive}. Details: #{b.url}"
  end
  
    
end