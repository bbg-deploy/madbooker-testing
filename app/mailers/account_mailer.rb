class AccountMailer < ActionMailer::Base
  default :from => MAILER_FROM_ADDRESS
  
  
  def invite invite
    @subject         = "#{invite.invited_by.f} has invited to join Less Projects"
    @person  = invite.person
    @inviter = invite.invited_by
    @recipients      = invite.person.email
    @content_type    = 'text/html'
  end
  
  
end
