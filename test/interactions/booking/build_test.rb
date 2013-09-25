require 'test_helper'



class Booking::BuildTest < ActiveSupport::TestCase
  
  
  def build
    @build ||= Booking::Build.new @context
  end
  
  context "build a booking with normal params and no sales taxes" do
    setup do
      @hotel = Gen.hotel
      params = Gen.booking(:arrive => "2013-03-13", :depart => "2013-03-15", bookable_id: 1, rate: 12.5).attributes.merge(:cc_number => "2341", :cc_cvv => "234")
      @context = Context.new params: params, hotel: @hotel, device_type: "mobile"      
    end

    should "be valid" do
      booking = nil
      assert_no_difference "Booking.count" do
        booking = build.run
      end
      assert booking.valid?
      assert booking.applied_sales_taxes.blank?
      assert_equal 25, booking.total
    end
  end
  
  context "build a booking with sales taxes" do
    setup do
      @hotel = Gen.hotel!
      Gen.sales_tax! hotel_id: @hotel.id, amount: 2.5, calculated_by: SalesTax::PER_NIGHT, calculated_how: SalesTax::FIXED_AMOUNT
      Gen.sales_tax! hotel_id: @hotel.id, amount: 3.5, calculated_by: SalesTax::PER_NIGHT, calculated_how: SalesTax::PERCENTAGE
      params = Gen.booking(:arrive => "2013-03-13", :depart => "2013-03-15", bookable_id: 1, rate: 12.5).attributes.merge(:cc_number => "2341", :cc_cvv => "234")
      @context = Context.new params: params, hotel: @hotel, device_type: "mobile"  
    end
  
    should "be valid" do
      booking = nil
      assert_no_difference "Booking.count" do
      assert_no_difference "AppliedSalesTax.count" do
        booking = build.run
      end
      end
       booking.valid?
       assert_equal 2, booking.applied_sales_taxes.size
       #12.5 for the room rate
       #.44 for the 3.5%
       #2.5 for the 2.5 nightly charge
       assert_equal 12.5 + 12.5 + 0.44 + 0.44 + 2.5 + 2.5, booking.total
    end
  end

  
  
end



