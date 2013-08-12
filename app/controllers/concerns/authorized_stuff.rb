module AuthorizedStuff
  extend ActiveSupport::Concern

  module ClassMethods
    
  end
  
  module InstanceMethods
    
    def redirect_unless_user_authorized
      redirect_to not_authorized_path unless user_authorized?
    end
    
    def user_authorized?
      return true unless current_hotel.log
      return true if controller_name == "home"
      return true if devise_controller?.log
      return true if hotel_from_subdomain.log
      return true if current_hotel.owner.log.payment_status.in?( %w(trialing active)).log
    end  
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end