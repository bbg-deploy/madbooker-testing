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
      @package_params ||= context.params[:package].permit :room_type_id, :rate, :discounted_rate, add_on_ids: []
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end