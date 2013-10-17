module Booking::Params
  module ClassMethods
    
  end
  
  module InstanceMethods
    
  
    def booking_params
      return @booking_params if @booking_params
      para = params_regardless_of_source
      para = munge_bookable para
      par = para[:booking].permit :arrive, :depart, :bookable_id, :bookable_type, :package_id, :first_name, :last_name,
        :email_confirmation, :email, :sms_confirmation, :cc_zipcode, :cc_cvv, :cc_year, 
        :cc_month, :cc_number
      par[:arrive] = Chronic.parse( para[:booking][:arrive]).to_date unless para[:booking][:arrive].blank?
      par[:depart] = Chronic.parse( para[:booking][:depart]).to_date unless para[:booking][:depart].blank?
      par
      @booking_params ||= par
    end
    
    private
    def munge_bookable params
      return params unless params[:booking][:bookable]
      bookable = params[:booking].delete :bookable
      letter, id = letter_and_id bookable
      bookable_type = bookable_type_from_letter letter
      bookable_id = id
      params[:booking][:bookable_id] = bookable_id
      params[:booking][:bookable_type] = bookable_type
      params
    end
    
    def letter_and_id str
      s = str.split ''
      l = s.shift
      id = s.join
      [l,id]
    end
    
    def bookable_type_from_letter letter
      if letter == "R"
        "RoomType"
      elsif letter == "P"
        "Package"
      end
    end
    
    def params_regardless_of_source
      if respond_to? :context
        para = context.params
      else
        para = params
      end
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end