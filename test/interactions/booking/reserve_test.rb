require 'test_helper'

class Booking::ReserveTest < ActiveSupport::TestCase
  
  def remove_non_permitted_attrs hash
    hash[:booking].delete_if {|k,v| k.to_s.in? %w(id hotel_id encrypted_cc_number encrypted_cc_cvv state customer_id rate discounted_rate created_at updated_at guid paid total) }
    hash
  end

  def reserve
    @reserve ||= Booking::Reserve.new context: @context
  end
  
  context "if inventory no longer available" do
    setup do
      Gen.room_type! id: 1
      params = ActionController::Parameters.new(remove_non_permitted_attrs( {:booking => Gen.booking( :arrive => "2013-03-13", :depart => "2013-03-17").attributes}))
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
      Gen.room_type! id: 1
      params = ActionController::Parameters.new(remove_non_permitted_attrs({:booking => Gen.booking(:cc_number => "", :arrive => "2013-03-13", :depart => "2013-03-14", bookable_id: 1, bookable_type: "RoomType").attributes}))
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
      Gen.sales_tax! hotel_id: @hotel.id
      Gen.room_type! id: 1
      params = ActionController::Parameters.new(remove_non_permitted_attrs({:booking => Gen.booking(:arrive => "2013-03-13", :depart => "2013-03-14", bookable_id: 1).attributes.merge(:cc_number => "2341", :cc_cvv => "234")}))
      @context = Context.new params: params, hotel: @hotel, device_type: "mobile"
      
      i = [Gen.inventory!(date: Date.new(2013, 3, 13), room_type_id: 1, hotel_id: @hotel.id, rate: 65)]
      rf = mock
      rf.stubs(:available_rooms).returns i
      rf.stubs(:all_rooms).returns({i.first.room_type_id => i})
      reserve.stubs(:room_finder).returns rf
    end
  
    should "return no error" do
      booking = nil
      assert_difference "Booking.count" do
      assert_difference "Sale.count" do
      assert_difference "AppliedSalesTax.count" do
        res = reserve.run
        assert !res.error?
        booking = res.object.booking
        assert_equal 75, booking.total
      end
      end
      end
      assert_equal "mobile", booking.sales.last.device_type
      assert_equal booking.total, booking.sales.last.total
    end
  end
  
  
  
end