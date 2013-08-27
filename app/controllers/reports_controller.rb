class ReportsController < ApplicationController
  
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
    @g_authed = g_authed?
    return unless @g_authed
    if params[:account_id]
      redirect_to ga_hotel_reports_path(profile_id: current_hotel.ga_profile_id) and return if current_hotel.ga_profile_id
      current_hotel.update_attribute :ga_account_id, params[:account_id]
      @profiles = less_ga.data.profiles params[:account_id]
      if @profiles[:items].size == 1
        redirect_to ga_hotel_reports_path(profile_id: @profiles[:items][0][:id])
      else
        render
      end
    elsif params[:profile_id]
      current_hotel.update_attribute :ga_profile_id, params[:profile_id]
      less_ga.profile_id = params[:profile_id]
      #@data = Reports::X.new(data: less_ga.data.visitors).run
      @data = less_ga.data.inbound
    else
      redirect_to ga_hotel_reports_path(account_id: current_hotel.ga_account_id) and return if current_hotel.ga_account_id
      @accounts = less_ga.data.accounts
      if @accounts[:items].size == 1
        redirect_to ga_hotel_reports_path(account_id: @accounts[:items][0][:id])
      else
        render
      end
    end
  end
  
  def google_auth
    redirect_to less_ga.auth.auth_url
  end
  
  
  def oauth2callback
    begin
      auth_hash = less_ga.auth.handle_callback params
      current_hotel.update_attributes correct_keys(auth_hash)
    rescue GaAuth::AccessDeniedError => e
      #display error message to user?
      Expecptions.record e
    rescue Signet::AuthorizationError =>e
      Expecptions.record e
    end
    redirect_to [:ga, current_hotel, :reports]
  end
  
  def remove_google_auth
    current_hotel.update_attributes :gauth_access_token => nil, :gauth_refresh_token => nil, :gauth_expires_in =>nil, :gauth_issued_at => nil
    redirect_to [:ga, current_hotel, :reports]
  end
  
  private
  def date_range
    @date_range ||= DateRange.from_params params
  end
  
  def g_authed?
    !current_hotel.gauth_access_token.blank?
  end
  
  def less_ga
    @less_ga ||= Ga.new client_id: App.ga_client_id,
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
  
end
