class InvitedsController < ApplicationController
  skip_filter :authenticate_user!
  
  def show
    build_em
    @user = User.new email: @membership.email
  end
  
  def create
    build_em
    @user = User.new sign_up_params

    if @user.save
      Membership.where(email: @user.email).update_all(:user_id => @user.id)
        sign_in(:user, @user)
        redirect_to @hotel
    else
      render action: "show"
    end    
  end
  
  private
  
  def build_em
    @membership = Membership.find_by_guid params[:guid]
    @hotel = @membership.hotel
  end
  
  def sign_up_params
    params[:user].permit :email, :password, :password_confirmation
  end
  
end
