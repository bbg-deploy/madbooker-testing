class LowInventoryMailer < ActionMailer::Base
  default from: App.from_address

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.booking_mailer.confirmation.subject
  #
  
  def low_inventory hotel, inventories
    @hotel = hotel.decorate
    @inventories = inventories
    mail to: @hotel.users.map(&:email), subject: "Low Inventory Report from MadBooker"
  end
end
