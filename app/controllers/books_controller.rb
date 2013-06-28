class BooksController < ApplicationController
  before_filter :ensure_hotel
  skip_filter :authenticate_user!
  layout "hotel"
  
  def show
    @booking = current_hotel.bookings.new.decorate
    @booking.step = 1
    render
  end
  
  def select_dates
    @booking = current_hotel.bookings.new(booking_params).decorate
    @booking.step = 2
    @available_rooms = Booking::RoomFinder.new(context: context).run.available_rooms
    render
  end
  
  def select_room
    @booking = current_hotel.bookings.new(booking_params).decorate
    @booking.step = 3
    render
  end
  
  def checkout
    @result = Booking::Reserve.new(context: context).run
    @booking = @result.object.booking.decorate
    @booking.step = 3
    render
  end
  
  private
  
  def booking_params
    par = params[:booking].permit :arrive, :depart, :room_type_id, :first_name, :last_name, :made_by_first_name,
      :made_by_last_name, :email_confirmation, :email, :sms_confirmation, :cc_zipcode, :cc_cvv, :cc_year, 
      :cc_month, :cc_number
    par[:arrive] = Chronic.parse( params[:booking][:arrive]).to_date unless params[:booking][:arrive].blank?
    par[:depart] = Chronic.parse( params[:booking][:depart]).to_date unless params[:booking][:depart].blank?
    par
  end
end
