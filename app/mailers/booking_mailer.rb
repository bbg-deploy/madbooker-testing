class BookingMailer < ActionMailer::Base
  default from: App.from_address

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.booking_mailer.confirmation.subject
  #
  def confirmation booking
    @booking = booking.decorate
    mail to: booking.email_confirmation, subject: "Your Hotel Booking"
  end
end
