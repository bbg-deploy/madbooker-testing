require 'test_helper'

class Booking::ReserveTest < MiniTest::Should::TestCase
  
  

  def reserve
    @reserve ||= Booking::Reserve.new context: @context
  end
  
  context "if inventory no longer available" do
    setup do
      params = ActiveSupport::HashWithIndifferentAccess.new({:booking => Gen.booking( :arrive => "2013-03-13", :depart => "2013-03-17").attributes})
      @context = Context.new params: params, hotel: Gen.hotel
    end

    should "return error" do
      res = reserve.run
      assert res.error?
      assert res.object.booking.new_record?
    end
  end
  
  
  context "if booking is not valid" do
    setup do
      @hotel = Gen.hotel
      params = ActiveSupport::HashWithIndifferentAccess.new({:booking => Gen.booking(:cc_number => "", :arrive => "2013-03-13", :depart => "2013-03-14", room_type_id: 1).attributes})
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
      assert res.object.booking.new_record?
    end
  end
  
  
  context "if booking is  valid" do
    setup do
      @hotel = Gen.hotel!
      params = ActiveSupport::HashWithIndifferentAccess.new({:booking => Gen.booking(:arrive => "2013-03-13", :depart => "2013-03-14", room_type_id: 1).attributes})
      @context = Context.new params: params, hotel: @hotel
      
      i = [Gen.inventory!(date: Date.new(2013, 3, 13), room_type_id: 1, hotel_id: @hotel.id)]
      rf = mock
      rf.stubs(:available_rooms).returns i
      rf.stubs(:all_rooms).returns({i.first.room_type_id => i})
      reserve.stubs(:room_finder).returns rf
    end

    should "return error" do
      assert_difference "Booking.count" do
      assert_difference "Sale.count" do
        res = reserve.run
        assert !res.error?
      end
      end
    end
  end
  
  
  
end