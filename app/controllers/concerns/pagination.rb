module Pagination
  extend ActiveSupport::Concern
  
  module ClassMethods
    
  end
  
  module InstanceMethods
      
    def page_number
      page ||= params[:page].to_i
      page = 1 if page < 1
      page
    end

    def pagination_params
      page_params = params.reject {|k,v| !k.in? [:page, :per_page]}
      page_params.merge!(per_page: 25, page: page_number)
    end

  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
    receiver.helper_method :pagination_params
  end
end