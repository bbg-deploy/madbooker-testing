class BookingsController < ApplicationController
  before_filter :ensure_hotel
  skip_filter :authenticate_user!

  def show
    if b = current_hotel.bookings.find_by_guid( params[:id])
      layout = 'hotel'
    elsif b = current_hotel.bookings.find_by_id( params[:id])
      layout = 'application'
    else
      raise ActiveRecord::RecordNotFound
    end
    
    @booking = b.decorate
    render layout: layout
  end
  
end
