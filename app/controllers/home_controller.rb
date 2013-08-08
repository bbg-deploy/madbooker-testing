class HomeController < ApplicationController
  skip_filter :authenticate_user!
  layout "brouchure"
  
  def index
    if !account_subdomain.blank?
      redirect_to hotel_from_subdomain.url
    else    
      render
    end
  end
  
  def not_authorized
    
  end
  
  def privacy
    render :layout => false
  end
  def terms
    render :layout => false
  end
end
