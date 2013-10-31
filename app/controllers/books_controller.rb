class BooksController < ApplicationController
  include Booking::Params

  before_filter :ensure_hotel
  before_filter :ensure_valid_hotel
  skip_filter :authenticate_user!
  layout "hotel"
  
  def show
    @booking = current_hotel.bookings.new.decorate
    @booking.step = 1
    Stat.funnel step: Stat::FUNNEL_STEPS[:start], context: context
    render
  end
  
  def select_dates
    @booking = current_hotel.bookings.new(booking_params).decorate
    @booking.step = 2
    @available_rooms = Booking::RoomFinder.new(context: context).run.available_rooms
    Stats::Search.new( context: context, available_rooms: @available_rooms).run
    Stat.funnel step: Stat::FUNNEL_STEPS[:choose_dates], context: context
    look_to_book!
    render
  end
  
  def select_room
    @booking = Booking::Build.new(Context.new(hotel: current_hotel, params: Booking::ParamsWithRate.new(context).run)).run
    @booking.step = 3
    Stat.funnel step: Stat::FUNNEL_STEPS[:choose_room], context: context
    render
  end
  
  def checkout
    @result = Booking::Reserve.new(context: context).run
    Stat.funnel step: Stat::FUNNEL_STEPS[:attempt], context: context
    if @result.success?
      @booking = @result.object.booking.decorate
      @booking.step = 3
      Stat.funnel step: Stat::FUNNEL_STEPS[:booked], context: context
      look_to_booked! 
    end
    render
  end
  
  private
  
  def current_hotel
    hotel_from_subdomain
  end
  
  def ensure_valid_hotel
    return if current_hotel
    render :file => "public/404.html", :layout => "brochure"
  end
  
end
