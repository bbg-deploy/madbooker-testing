class CheckInsController < ApplicationController
  
  def index
    @bookings = current_hotel.bookings.open.for_date(params[:date]).by_last_name.decorate
    render
  end
  
  def show
    @booking = current_hotel.bookings.find(params[:id]).decorate
    render
  end
  
end
