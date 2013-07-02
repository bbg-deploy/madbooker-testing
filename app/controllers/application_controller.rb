class ApplicationController < ActionController::Base
  include Pagination
  include Rendering
  include DeviseStuff
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_user!


  def current_hotel
    @current_hotel ||= hotel_for_user
  end
  helper_method :current_hotel

  
  def title t = nil
    return @title if t.nil?
    @title = t
  end
  helper_method :title
  
  def context
    @context ||= Context.new hotel: current_hotel, user: current_user, params: params
  end
  
  
  private
  def hotel_for_user
    Hotel.where("user_id = ?", current_user.try( :id)).first
  end
  
  
  def hotel_from_subdomain
    #don't use @current_hotel cuz that is for authenticated users
    @hotel ||= Hotel.where("subdomain = ?", account_subdomain).first
  end
  
    
  def account_subdomain
    tld_length = App.domain.split(".").size - 1
    sub = request.subdomain(tld_length) || ''
    return sub if sub.blank?
    return sub unless SUBDOMAIN_EXCLUSIONS.any?{|e| e == sub}
    ''
  end
  
  def ensure_hotel
    return if current_hotel
    return unless account_subdomain.blank?
    raise "do something here when there's no subdomain" 
  end

  
end
