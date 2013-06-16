class Context
  attr_accessor :hotel, :user, :params
  
  def initialize(args)
    self.hotel  = args[:hotel]
    self.user   = args[:user]
    self.params = args[:params]
  end 
  
end