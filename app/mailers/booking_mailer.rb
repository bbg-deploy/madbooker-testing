class BookingMailer < ActionMailer::Base
  default from: "booking@madbooker.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.booking_mailer.confirmation.subject
  #
  def confirmation booking
    @booking = booking
    mail to: booking.email_confirmation, subject: "Your Hotel Booking"
  end
end
