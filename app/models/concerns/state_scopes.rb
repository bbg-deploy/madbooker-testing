module StateScopes
  extend ActiveSupport::Concern
  
  module ClassMethods
  end
  
  module InstanceMethods
    
  end
  
  included do
    scope :open, ->{where state: :open}
    scope :no_shows, ->{where state: :no_show}
    
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end