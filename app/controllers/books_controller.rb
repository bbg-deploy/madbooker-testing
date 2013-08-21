class BooksController < ApplicationController
  include Booking::Params

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
    Stats::Search.new( context: context, available_rooms: @available_rooms).run
    look_to_book!
    render
  end
  
  def select_room
    @booking = current_hotel.bookings.new(Booking::ParamsWithRate.new(context).run).decorate
    @booking.step = 3
    render
  end
  
  def checkout
    @result = Booking::Reserve.new(context: context).run
    @booking = @result.object.booking.decorate
    @booking.step = 3
    look_to_booked!
    render
  end
  
  private
  
  def current_hotel
    hotel_from_subdomain
  end
  
end
