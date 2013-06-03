class HomeController < ApplicationController
  def index
  end
  
  
  def privacy
    render :layout => false
  end
  def terms
    render :layout => false
  end
end
