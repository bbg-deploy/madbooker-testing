class HomeController < ApplicationController
  skip_filter :authenticate_user!
  layout "brochure"
  
  def index
    if !account_subdomain.blank?
      redirect_to hotel_from_subdomain.url
    else    
      redirect_to new_user_session_path
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
