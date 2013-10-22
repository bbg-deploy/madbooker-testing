class PaymentMailer < ActionMailer::Base
  default from: App.from_address
  
  def charged_failed_1 user
    mail_it user
  end
  
  def charged_failed_2 user
    mail_it user
  end
  
  def charged_failed_3 user
    mail_it user
  end
  
  private
  def mail_it user
    @user = user
    mail to: user.email, subject: "Credit Card failed for Madbooker.com"
  end
  
end
