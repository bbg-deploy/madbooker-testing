class PaymentMailer < ActionMailer::Base
  default from: App.from_address
  
  def charged_failed user
    @user = user
    mail to: user.email, subject: "Credit Card failed for Madbooker.com"
  end
  
end
