class Membership::Invite < Less::Interaction
  
  expects :context
  
  def run    
    invite unless add.new_record?
    @membership
  end
  
  private
  
  def user
    @user = User.find_by_email context.params[:membership][:email]
  end
  
  def add
    @membership = context.hotel.memberships.create email: context.params[:membership][:email], guid: UUIDTools::UUID.random_create.to_s.gsub("-", ""), user_id: user.try(:id)#it's ok if it's nill here
  end
  
  def invite
    MembershipMailer.invite(@membership, context.user, context.hotel).deliver
  end
  
  
  
end