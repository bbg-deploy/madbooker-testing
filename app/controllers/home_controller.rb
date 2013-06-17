class HomeController < ApplicationController
  skip_filter :authenticate_user!
  
  def index
    redirect_to current_hotel.url and return if current_hotel
    
    render
  end
  
  
  def privacy
    render :layout => false
  end
  def terms
    render :layout => false
  end
end
