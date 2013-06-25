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
    @available_rooms = Booking::RoomFinder.new(context: context).run.object
    render
  end
  
  def select_room
    @booking = current_hotel.bookings.new(booking_params).decorate
    @booking.step = 3
    render
  end
  
  def checkout
    result = Booking::Reserve.new(context: context).run
    if result.success?
      flash[:last_booking] = result.object.booking_id
      redirect_to action: :confirmation
    else
      @booking = result.object.booking
      render
    end
  end
  
  
  private
  def ensure_hotel
    return if current_hotel
    raise "do something here when there's no subdomain" 
  end
  
  
  def booking_params
    par = params[:booking].permit :arrive, :depart, :inventory_id
    par[:arrive] = Chronic.parse( params[:booking][:arrive]).to_date unless params[:booking][:arrive].blank?
    par[:depart] = Chronic.parse( params[:booking][:depart]).to_date unless params[:booking][:depart].blank?
    par
  end
end
