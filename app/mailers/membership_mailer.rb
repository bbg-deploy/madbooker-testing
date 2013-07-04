class MembershipMailer < ActionMailer::Base
  default from: App.from_address
  
  
  def invite membership, from, hotel
    @membership = membership.decorate
    @from = from.decorate
    @hotel = hotel.decorate
    mail to: membership.email, subject: "You've been invited to join #{hotel.name}"
  end
end
