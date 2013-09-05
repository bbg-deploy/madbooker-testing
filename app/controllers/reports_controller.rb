class ReportsController < ApplicationController
  before_filter :ensure_g_auth, only: [:visits, :cities, :sources]
  rescue_from Signet::AuthorizationError, with: :handle_ga_auth_error
  
  
  def show
    render    
  end
  
  def searches
    @searches = current_hotel.stats.searches.range(date_range.to_r)
    render action: :show
  end
  
  def revenue
    @revenue = Reports::Revenue.new(context:context).run
  end
  
  def revenue_by_room_type    
    @revenue_by_room = Reports::RevenueByRoomType.new(context:context).run
  end
  
  def daily
    @adr = Reports::AverageDailyRate.new(context).run
  end
  
  def funnel
    @funnel = Reports::Funnel.new(context).run
  end
  
  def ga
    render and return unless g_authed?
    
    store_ga_attributes

    ga = Hotel::Ga.new(context, :less_ga => less_ga).run
    if ga.go_to_report?
      redirect_to visits_hotel_reports_path(current_hotel)
      return
    elsif ga.need_to_pick_account?
      @accounts = ga.accounts
    elsif ga.need_to_pick_profile?
      @profiles = ga.profiles
    else
      #prob chose a goog account that doesn't match the hotel.google_analytics_code
      current_hotel.remove_google
      @error = "We didn't find any Google Analytics accounts or profile that match the Google Analytics Code that is stored in the Hotel's Settings. Please double check everything."
    end
    render
  end
  
  def visits
    @data = Reports::Visits.new(data: less_ga.data.inbound).run
  end
  
  def sources
    @data = Reports::Bar.new(data: less_ga.data.sources, dimension: "ga:source").run
  end
  
  def cities
    @data = Reports::Bar.new(data: less_ga.data.cities, dimension: "ga:city").run
  end
  
  def google_auth
    redirect_to less_ga.auth.auth_url
  end
  
  
  def oauth2callback
    begin
      auth_hash = less_ga.auth.handle_callback params
      current_hotel.update_attributes correct_keys(auth_hash)
    rescue Less::Ga::Auth::AccessDeniedError => e
      #display error message to user?
      Exceptions.record e
    rescue Signet::AuthorizationError =>e
      Exceptions.record e
    end
    redirect_to [:ga, current_hotel, :reports]
  end
  
  def remove_google_auth
    current_hotel.remove_google
    redirect_to [:ga, current_hotel, :reports]
  end
  
  private
  def ensure_g_auth
    redirect_to ga_hotel_reports_path(current_hotel) unless g_authed? && g_setup?
  end
  
  def date_range
    @date_range ||= DateRange.from_params params
  end
  
  def g_authed?
    !current_hotel.gauth_access_token.blank? && 
    !current_hotel.google_analytics_code.blank?
  end
  helper_method :g_authed?
  
  def g_setup?
    !current_hotel.ga_account_id.blank? &&
    !current_hotel.ga_profile_id.blank?
  end
  
  def handle_ga_auth_error ex
    Exceptions.record ex
    current_hotel.remove_google
    redirect_to [:ga, current_hotel, :reports]
  end
  
  def less_ga
    @less_ga ||= Less::Ga::Sb.new client_id: App.ga_client_id,
      client_secret: App.ga_client_secret,
      auth_callback_url: oauth2callback_url, 
      webproperty: current_hotel.google_analytics_code, 
      access_token: current_hotel.gauth_access_token, 
      refresh_token: current_hotel.gauth_refresh_token, 
      google_analytics_code: current_hotel.google_analytics_code,
      profile_id: current_hotel.ga_profile_id,
      refresh_callback: ->(access_token){current_hotel.update_attribute :gauth_access_token, access_token}
  end
  
  
  def correct_keys hash
    h = {}
    h[:gauth_access_token]  = hash[:access_token]
    h[:gauth_refresh_token] = hash[:refresh_token]
    h[:gauth_expires_in]    = hash[:expires_in]
    h[:gauth_issued_at]     = hash[:issued_at]
    h    
  end

  def store_ga_attributes
    current_hotel.update_attribute( :ga_account_id, params[:account_id]) if params[:account_id]
    current_hotel.update_attribute( :ga_profile_id, params[:profile_id]) if params[:profile_id]
  end
  
end
