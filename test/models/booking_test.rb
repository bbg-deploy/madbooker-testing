require "test_helper"

class BookingTest < ActiveSupport::TestCase
    
  #testing the initial state on create is done in the reserve_test "if booking is  valid :: return no error"
  context "after save update" do
    setup do
      @booking = Gen.booking! state: "open"
      1.upto 3 do |i|
        Gen.sale! booking_id: @booking.id, state: "open"
      end
    end

    should "update state in sales" do
      @booking.check_out!
      @booking.reload.sales.each do |s|
        assert_equal "checked_out", s.state
      end
    end
    
    should "not update state if state didn't change" do
      @booking.update_attributes! rate: 2
      @booking.reload.sales.each do |s|
        assert_equal "open", s.state
      end
    end
  end
  
end
