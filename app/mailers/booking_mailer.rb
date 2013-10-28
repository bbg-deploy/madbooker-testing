class BookingMailer < ActionMailer::Base
  default from: App.from_address
  
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.booking_mailer.confirmation.subject
  #
  def confirmation booking
    @booking = booking.decorate
    mail to: booking.email, subject: "Your Hotel Booking", from: booking.hotel.public_email_address
  end
  
  def hotel_confirmation booking
    @booking = booking.decorate
    mail to: booking.hotel.email, subject: "A New Booking from Madbooker"
  end
end
