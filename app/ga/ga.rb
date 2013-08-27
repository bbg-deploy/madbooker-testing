
require 'google/api_client'

# 
# module Less
# end


class Ga
#require 'less/ga/auth'
  
  attr_accessor :client_id, :client_secret, :webproperty, :scope, :auth_callback_url, :access_token, :google_analytics_code, :hotel, :refresh_token, :profile_id
  
  # Initialize the auth object
  # @param [String] client_id    The client_id supplied to your app while registering your app with google
  # @param [String] client_secret    The client_secret supplied to your app while registering your app with google
  # @param [String] webproperty   Optional. The id for the analytics you're going after. Can be found using the webproperties method
  # @param [String] scope    Optional. Defaults to 'https://www.googleapis.com/auth/analytics.readonly'
  def initialize(client_id: "", client_secret: "", webproperty: nil, scope: "https://www.googleapis.com/auth/analytics.readonly", auth_callback_url: "", access_token: "", google_analytics_code: "", refresh_token: "", profile_id: "")
    self.client_id         = client_id
    self.client_secret     = client_secret
    self.webproperty       = webproperty
    self.scope             = scope
    self.auth_callback_url = auth_callback_url
    self.access_token      = access_token
    self.refresh_token     = refresh_token
    self.profile_id        = profile_id
    self.google_analytics_code = google_analytics_code
  end
  
  def auth
    @auth ||= ::GaAuth.new client_id: @client_id, client_secret:@client_secret, scope: @scope, auth_callback_url: @auth_callback_url, access_token: access_token, refresh_token: refresh_token
  end
  
  def data
    @data ||= ::GaData.new profile_id: profile_id, access_token: access_token, ga: self
  end
  
  def accounts
    data.send :get, "https://www.googleapis.com/analytics/v3/management/accounts"
  end
  
  def profiles account_id
    data.send :get,  "https://www.googleapis.com/analytics/v3/management/accounts/#{account_id}/webproperties/#{@google_analytics_code}/profiles"
  end
  
  # def access_token= str
  #   auth.access_token = str
  # end
  
  
  
end