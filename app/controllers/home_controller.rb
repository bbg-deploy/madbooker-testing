class HomeController < ApplicationController
  skip_filter :authenticate_user!
  
  def index
    if !account_subdomain.blank?
      redirect_to current_hotel.url
    else    
      render
    end
  end
  
  
  def privacy
    render :layout => false
  end
  def terms
    render :layout => false
  end
end
