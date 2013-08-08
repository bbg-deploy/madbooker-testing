class MembershipsController < ApplicationController
  
  def index
    render
  end
  
  def create
    @membership = Membership::Invite.new(context: context.replace_params(membership_params, :membership)).run
    render
  end
  
  def destroy
    @membership = current_hotel.memberships.find(params[:id]).destroy
    render
  end
  
  
  private
  def membership_params
    params[:membership].permit :email
  end
  
end
