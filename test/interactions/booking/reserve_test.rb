require 'test_helper'

class Booking::ReserveTest < ActiveSupport::TestCase
  
  def reserve
    @reserve ||= Booking::Reserve.new context: @context
  end
  
  context "if inventory no longer available" do
    setup do
      Gen.room_type! id: 1
      params = ActionController::Parameters.new(remove_non_permitted_booking_attrs( {:booking => Gen.booking( :arrive => "2013-03-13", :depart => "2013-03-17").attributes}))
      @context = Context.new params: params, hotel: Gen.hotel
    end
  
    should "return error" do
      res = reserve.run
      assert res.error?
      assert res.object.booking.nil?
    end
  end
    
  
  context "if booking is not valid" do
    setup do
      @hotel = Gen.hotel
      Gen.room_type! id: 1
      params = ActionController::Parameters.new(remove_non_permitted_booking_attrs({:booking => Gen.booking(:cc_number => "", :arrive => "2013-03-13", :depart => "2013-03-14", bookable_id: 1, bookable_type: "RoomType").attributes}))
      @context = Context.new params: params, hotel: @hotel
      
      i = [Gen.inventory(date: Date.new(2013, 3, 13), room_type_id: 1)]
      rf = mock
      rf.stubs(:available_rooms).returns i
      rf.stubs(:all_rooms).returns({i.first.room_type_id => i})
      reserve.stubs(:room_finder).returns rf
    end
  
    should "return error" do
      res = reserve.run
      assert res.error?
      assert res.object.booking.nil?
    end
  end
  
  
  context "if booking is  valid" do
    setup do
      @hotel = Gen.hotel!
      Gen.sales_tax! hotel_id: @hotel.id
      Gen.room_type! id: 1
      params = ActionController::Parameters.new(remove_non_permitted_booking_attrs({:booking => Gen.booking(:arrive => "2013-03-13", :depart => "2013-03-15", bookable_id: 1).attributes.merge(:cc_number => "2341", :cc_cvv => "234")}))
      @context = Context.new params: params, hotel: @hotel, device_type: "mobile"
      
      i = [Gen.inventory!(date: Date.new(2013, 3, 13), room_type_id: 1, hotel_id: @hotel.id, rate: 65),
        Gen.inventory!(date: Date.new(2013, 3, 14), room_type_id: 1, hotel_id: @hotel.id, rate: 65)]
      room_finder = mock
      room_finder.stubs(:available_rooms).returns i
      room_finder.stubs(:all_rooms).returns({i.first.room_type_id => i})
      reserve.stubs(:room_finder).returns room_finder
    end
  
    should "return no error" do
      booking = nil
      assert_difference "Booking.count" do
      assert_difference "Sale.count", 2 do
      assert_difference "AppliedSalesTax.count" do
        res = reserve.run
        assert !res.error?
        booking = res.object.booking
      end
      end
      end
      assert_equal 150, booking.total
      booking.sales.each do |sale|
        assert_equal "mobile", sale.device_type
        assert_equal 75, sale.total
        assert_equal booking.state.to_s, sale.state.to_s
      end
    end
  end
  
  
  
end