require 'test_helper'

class Cron::CleanUpCreditCardsTest < ActiveSupport::TestCase


  def clean_up_credit_card
    @clean_up_credit_card ||= Cron::CleanUpCreditCards.new nil
  end
  
  context "when nothing to clean up" do
    setup do
      -10.upto 14 do |i|
        Gen.booking! arrive: Date.current+i, depart: Date.current+i+2
      end
    end

    should "clean nothing" do
      assert_no_difference "Booking.need_cleanup.count" do
        clean_up_credit_card.run
      end
    end
  end
  
  context "when some to clean up" do
    setup do
      -21.upto 14 do |i|
        Gen.booking! arrive: Date.current+i, depart: Date.current+i+2
      end
    end

    should "clean only in the past" do
      assert_difference "Booking.need_cleanup.count", -7 do
        clean_up_credit_card.run
      end
    end
  end
  
  

  
  
  
end