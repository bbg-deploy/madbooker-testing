class BooksController < ApplicationController
  before_filter :ensure_hotel
  skip_filter :authenticate_user!
  layout "hotel"
  
  def show
    #render "select_dates"
    res current_hotel.bookings.new.decorate
  end
  
  def select_dates
    Booking::RoomFinder.new(context: context).run
    
  end
  
  def select_room
    
  end
  
  def checkout
    
  end
  
  
  private
  def ensure_hotel
    return if current_hotel
    raise "do something here when there's no subdomain" 
  end
end
