class HomeController < ApplicationController
  skip_filter :authenticate_user!
  
  def index
  end
  
  
  def privacy
    render :layout => false
  end
  def terms
    render :layout => false
  end
end
