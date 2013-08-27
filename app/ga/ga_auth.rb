

class GaAuth
  
  class GaAuth::AccessDeniedError < StandardError; end

  attr_accessor :scope, :ga

  # Initialize the auth object
  # @param [String] client_id    The client_id supplied to your app while registering your app with google
  # @param [String] client_secret    The client_secret supplied to your app while registering your app with google
  # @param [String] scope    Optional. Defaults to 'https://www.googleapis.com/auth/analytics.readonly'
  def initialize(scope: "https://www.googleapis.com/auth/analytics.readonly", ga: nil)
    self.scope          = scope
    self.ga = ga
  end
  
  def auth_url
    user_credentials.authorization_uri.to_s
  end
  
  def handle_callback params
    raise GaAuth::AccessDeniedError if params[:error] == "access_denied"
    user_credentials.code = params[:code]
    user_credentials.fetch_access_token!.with_indifferent_access
  end
  
  def reauthorize
    #{"access_token"=>"ya29.AHES6ZSesJMBes2nCdNSKNzuiuOddSqdssRUNt7HyCChBDzXPtpbpsM", "token_type"=>"Bearer", "expires_in"=>3600}
    #{"error"=>{"errors"=>[{"domain"=>"global", "reason"=>"required", "message"=>"Login Required", "locationType"=>"header", "location"=>"Authorization"}], "code"=>401, "message"=>"Login Required"}}
    h = {}
    h[:access_token] = ga.access_token
    h[:refresh_token] = ga.refresh_token
    u = user_credentials h
    u.refresh!.with_indifferent_access
  end
  
  
  
  private
  
  
  def client
    return @client if @client
    client = Google::APIClient.new
    client.authorization.client_id = ga.client_id
    client.authorization.client_secret = ga.client_secret
    client.authorization.scope = @scope
    @client = client
  end
  
  def user_credentials token_hash = {}
    @authorization ||= (
      auth = client.authorization.dup
      auth.redirect_uri = ga.auth_callback_url
      auth.update_token!(token_hash)
      auth
    )
  end

end
