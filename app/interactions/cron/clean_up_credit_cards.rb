class Cron::CleanUpCreditCards < Less::Interaction
  
  
  
  def run
    Booking.need_cleanup.update_all encrypted_cc_number: nil, encrypted_cc_cvv: nil, cc_month: nil, cc_year: nil, cc_zipcode: nil
  end
  
  private
  

end