class ApplicationController < ActionController::Base
  include Pagination
  include Rendering
  include DeviseStuff
  include StatsStuff
  include AuthorizedStuff
  
  protect_from_forgery with: :exception
  before_filter :ensure_https
  before_filter :authenticate_user!
  around_filter :set_time_zone
  before_filter :set_reservation_cookie
  after_filter :store_page_stat
  before_filter :redirect_unless_user_authorized

  layout :select_layout

  
  def current_hotel
    @current_hotel ||= hotel_for_user
  end
  helper_method :current_hotel
  

  def title t = nil
    return @title = t unless t.nil?
    return @title unless @title.nil?
    @title = "Madbooker"
  end
  helper_method :title

  def context
    @context ||= Context.new hotel: current_hotel, user: current_user, params: params, device_type: device_type, user_bug: user_bug
  end
  


  private
  #Remember:
  # DO
  # 2.hours.ago # => Fri, 02 Mar 2012 20:04:47 JST +09:00
  # 1.day.from_now # => Fri, 03 Mar 2012 22:04:47 JST +09:00
  # Date.today.to_time_in_current_zone # => Fri, 02 Mar 2012 22:04:47 JST +09:00
  # Date.current # => Fri, 02 Mar
  # Time.zone.parse("2012-03-02 16:05:37") # => Fri, 02 Mar 2012 16:05:37 JST +09:00
  # Time.zone.now # => Fri, 02 Mar 2012 22:04:47 JST +09:00
  # Time.current # Same thing but shorter. (Thank you Lukas Sarnacki pointing this out.)
  # Time.zone.today # If you really can't have a Time or DateTime for some reason
  # Time.zone.now.utc.iso8601 # When supliyng an API (you can actually skip .zone here, but I find it better to always use it, than miss it when it's needed)
  # Time.strptime(time_string, '%Y-%m-%dT%H:%M:%S%z').in_time_zone(Time.zone) # If you can't use Time#parse
  # DON’Ts
  # Time.now # => Returns system time and ignores your configured time zone.
  # Time.parse("2012-03-02 16:05:37") # => Will assume time string given is in the system's time zone.
  # Time.strptime(time_string, '%Y-%m-%dT%H:%M:%S%z') # Same problem as with Time#parse.
  # Date.today # This could be yesterday or tomorrow depending on the machine's time zone.
  # Date.today.to_time # => # Still not the configured time zone.
  def set_time_zone &block
    unless private_or_public_hotel
      Time.use_zone "UTC", &block
    else
      Time.use_zone private_or_public_hotel.time_zone, &block
    end
  end
  
  def hotel_for_user
    return nil unless current_user
    hotel = current_user.hotels.find_by_id(params[:hotel_id] || params[:id])
    hotel ||= current_user.hotels.first
  end
  
  def private_or_public_hotel
    current_hotel || hotel_from_subdomain
  end
   
   
  def hotel_from_subdomain
    #don't use @current_hotel cuz that is for authenticated users
    @hotel ||= Hotel.where("subdomain = ?", account_subdomain).first
  end
  
    
  def account_subdomain
    return @sub if @sub
    return @sub = "" if request.host == App.domain
    @sub = request.subdomains.first || ''
    return @sub if @sub.blank?
    return @sub unless SUBDOMAIN_EXCLUSIONS.any?{|e| e == @sub}
    @sub = ""
  end
  
  def ensure_hotel
    return if current_hotel
    return unless account_subdomain.blank?
    render :file => "public/401.html", :status => :unauthorized, :layout => "brochure"
  end
  
  def ensure_https
    return unless Rails.env.production?
    return if request.ssl?
    redirect_to :protocol => 'https', status: 301
  end

  def select_layout
    if devise_controller? && resource_name == :user && action_name.in?( ['new', "create"])
      "simple"
    else
      "application"
    end
  end

end
