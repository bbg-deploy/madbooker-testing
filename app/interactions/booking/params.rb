module Booking::Params
  module ClassMethods
    
  end
  
  module InstanceMethods
    
  
    def booking_params
      return @booking_params if @booking_params
      if respond_to? :context
        para = context.params
      else
        para = params
      end
      par = para[:booking].permit :arrive, :depart, :bookable_id, :bookable_type, :package_id, :first_name, :last_name, :made_by_first_name,
        :made_by_last_name, :email_confirmation, :email, :sms_confirmation, :cc_zipcode, :cc_cvv, :cc_year, 
        :cc_month, :cc_number
      par[:arrive] = Chronic.parse( para[:booking][:arrive]).to_date unless para[:booking][:arrive].blank?
      par[:depart] = Chronic.parse( para[:booking][:depart]).to_date unless para[:booking][:depart].blank?
      par
      @booking_params ||= par
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end