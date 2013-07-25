class Context
  attr_accessor :hotel, :user, :params, :mobile, :user_bug
  
  def initialize(hotel: nil, user: nil, params: params, mobile: nil, user_bug: "")
    self.hotel    = hotel
    self.user     = user
    self.params   = params
    self.mobile   = mobile
    self.user_bug = user_bug
  end 
  
  def replace_params h, key = nil
    if key.nil?
      @params = h
    else
      @params[key] = h
    end
    self
  end
  
end