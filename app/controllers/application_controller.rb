class ApplicationController < ActionController::Base
  include Pagination
  include Rendering
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_user!


  def current_hotel
    @current_hotel ||= hotel_for_user
  end

  def after_sign_in_path_for(resource)
    return hotel_path(current_hotel) unless current_hotel.blank?
    new_hotel_path
  end
  
  def after_sign_out_path_for(resource)
    root_path
  end
  
  
  def title t = nil
    return @title if t.nil?
    @title = t
  end
  helper_method :title
  
  
  private
  def hotel_for_user
    @current_hotel = Hotel.where("subdomain = ?", account_subdomain).first
    @current_hotel ||= Hotel.where("user_id = ?", current_user.id).first
  end
  
    
  def account_subdomain
    sub = request.subdomains(1).first || ''
    return sub if sub.blank?
    return x unless SUBDOMAIN_EXCLUSIONS.any?{|e| e == sub}
    ''
  end

  
end
