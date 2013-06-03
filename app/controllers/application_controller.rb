class ApplicationController < ActionController::Base
  protect_from_forgery
  
  
  def current_person
    current_user.person
  end
  helper_method :current_person
  
  def after_sign_in_path_for resource
    projects_path
  end
end
