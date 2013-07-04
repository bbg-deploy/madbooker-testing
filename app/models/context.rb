class Context
  attr_accessor :hotel, :user, :params
  
  def initialize(args)
    self.hotel  = args[:hotel]
    self.user   = args[:user]
    self.params = args[:params]
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