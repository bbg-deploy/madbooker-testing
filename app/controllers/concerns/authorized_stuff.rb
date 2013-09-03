module AuthorizedStuff
  extend ActiveSupport::Concern

  module ClassMethods
    
  end
  
  module InstanceMethods
    
    def redirect_unless_user_authorized
      redirect_to not_authorized_path unless user_authorized?
    end
    
    def user_authorized?
      return true unless current_hotel
      return true if controller_name == "home"
      return true if devise_controller?
      return true if hotel_from_subdomain
      return true if current_hotel.owner.paying?
    end  
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end