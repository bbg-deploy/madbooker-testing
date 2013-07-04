class UserDecorator < ApplicationDecorator
  delegate_all

  def name
    email
  end

end
