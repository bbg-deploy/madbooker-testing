module Packages::Params
  module ClassMethods
    
  end
  
  module InstanceMethods
    
    private
  
    def add_on_ids
      @add_on_ids ||= package_params.delete( :add_on_ids).reject {|x| x.blank?}
    end
    alias_method :clean_add_on_ids, :add_on_ids
  
  
    def package_params
      return @package_params if @package_params
      if respond_to? :context
        para = context.params
      else
        para = params
      end
      @package_params ||= para[:package].permit :room_type_id, :additional_price, add_on_ids: []
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end