class StripesController < ApplicationController
  
  skip_filter :authenticate_user!
  skip_filter :set_time_zone
  skip_filter :set_reservation_cookie
  skip_filter :store_page_stat
  skip_before_action :verify_authenticity_token
  
  respond_to :html, :js, :json, :xml
  
  def event
    Payments::Notification.new(context).run
    render :text => ""
  end
end
