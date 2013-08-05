module DeviseStuff
  module ClassMethods
    
  end
  
  module InstanceMethods
    
    def after_update_path_for(resource)
      after_sign_in_path_for resource
    end
  
    def after_sign_in_path_for(resource)
      return edit_hotel_path(current_hotel) unless current_hotel.blank?
      new_hotel_path
    end
  
    def after_sign_out_path_for(resource)
      root_path
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:time_zone, :email, :password, :password_confirmation, :current_password) }
    end
      
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
    receiver.before_filter :configure_permitted_parameters, if: :devise_controller?
  end
end