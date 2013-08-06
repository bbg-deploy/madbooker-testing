class StripesController < ApplicationController
  
  skip_filter :authenticate_user!
  skip_filter :set_time_zone
  skip_filter :set_reservation_cookie
  skip_filter :store_page_stat
  
  def event
    event = request.body.read.log
    render :text => ""
  end
  
end
