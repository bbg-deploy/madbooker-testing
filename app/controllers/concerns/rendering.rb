module Rendering
  extend ActiveSupport::Concern
  
  module ClassMethods
  end
  
  module InstanceMethods
      
    def res object, name = nil, render_options = {}, &block
      create_resource_helper_methods_for object, name
      respond_with object, render_options, &block
    end
  
    def create_resource_helper_methods_for decorated_object, name = nil
      name = discern_name( decorated_object) unless name
      if Rails.env.test?
        instance_variable_set "@#{name}", decorated_object
      end
      ApplicationHelper.class_eval do
        define_method name do
          decorated_object
        end
        alias_method :resource, name
      end
      decorated_object
    end
  
    def discern_name object
      singular = object.class.to_s.underscore
      if !(singular =~ /_decorator/) && object.respond_to?(:first) && object.empty?
        #empty array, we can't get the name
        raise "must supply name for an empty array"
      elsif !(singular =~ /_decorator/) && object.respond_to?(:first)
        #not a decorated array, get the name from the first object
        singular = object.first.class.to_s.underscore
      end

      singular = singular.gsub("_decorator", "")
      if object.respond_to?(:first)
        singular.pluralize.to_sym
      else
        singular.to_sym
      end
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
    receiver.respond_to :html

  end
end