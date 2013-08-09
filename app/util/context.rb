class Context
  attr_accessor :hotel, :user, :params, :device_type, :user_bug
  
  def initialize(hotel: nil, user: nil, params: params, device_type: nil, user_bug: "")
    self.hotel         = hotel
    self.user          = user
    self.params        = params
    self.device_type   = device_type
    self.user_bug      = user_bug
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