class MembershipDecorator < ApplicationDecorator
  delegate_all
  
  decorates_association :user

  def name
    email
  end

end
