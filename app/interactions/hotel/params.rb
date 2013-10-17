module Hotel::Params
  module ClassMethods
    
  end
  
  module InstanceMethods
    
    private
  
  
  
    def hotel_params
      params = params_from_either_context_or_direct
      
      if params.respond_to? :permit
        pa = params.permit :user_id, :name, :address, :url, :phone, :fax, 
          :url, :room_rates_display, :subdomain, :google_analytics_code, :time_zone,
          :fine_print, :logo, :room_rates_display, :minimal_inventory_notification_threshold, 
          :currency_id, :street1, :street2, :street3, :city, :state, :country, :postal_code, :email,
          :google_analytics_code_type, :max_occupancy,
          :room_types_attributes => [:name, :description, :number_of_rooms, 
          :default_rate, :discounted_rate, :_destroy, :id, :image]
      else
        pa = params
      end
      if pa[:logo].nil?
        pa.delete(:logo) 
      end
      pa
    end
    
    def params_from_either_context_or_direct
      if respond_to? :params
        params[:hotel]
      elsif respond_to? :context
        context.params[:hotel]
      end      
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end