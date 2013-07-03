require 'test_helper'


class Array
  def for_date date
    self
  end
end

class Booking::ListTest < MiniTest::Should::TestCase
  
  def percentage inventory
    inventory.sales_count.to_d / inventory.available_rooms * 100
  end

  def list
    @list ||= Booking::List.new context: @context
  end
  
  context "with no inventory" do
    setup do
      @hotel = Gen.hotel
      @room_types = [Gen.room_type, Gen.room_type]
      @hotel.stubs(:room_types).returns @room_types
      @hotel.stubs(:inventories).returns []
      @hotel.stubs(:bookings).returns []
      params = {date: "2013-03-13"}
      @context = Context.new params: params, hotel: @hotel
    end

    should "return empty array" do
      l = list.run
      assert_equal 2, l.size
      [0,1].each do |i|
        assert_equal @room_types[i].name, l[i].name
        assert_nil l[i].available
        assert_nil l[i].booked
        assert_nil l[i].percent_booked
        assert_equal [], l[i].rooms
      end
    end
  end
  
  context "with inventory but no bookings" do
    setup do
      @hotel = Gen.hotel
      @room_types = [Gen.room_type(id: 1), Gen.room_type(id: 2)]
      @hotel.stubs(:room_types).returns @room_types
      @inventory = [Gen.inventory(room_type_id: @room_types[0].id), Gen.inventory(room_type_id: @room_types[1].id)]
      @hotel.stubs(:inventories).returns @inventory
      @hotel.stubs(:bookings).returns []
      params = {date: "2013-03-13"}
      @context = Context.new params: params, hotel: @hotel
    end

    should "have the proper data" do
      l = list.run
      assert_equal 2, l.size
      [0,1].each do |i|
        assert_equal @room_types[i].name, l[i].name
        assert_equal @inventory[i].available_rooms, l[i].available
        assert_equal @inventory[i].sales_count, l[i].booked
        assert_equal percentage(@inventory[i]), l[i].percent_booked
        assert_equal [], l[i].rooms
      end
    end
  end
  
  context "with inventory and bookings" do
    setup do
      @hotel = Gen.hotel
      @room_types = [Gen.room_type(id: 1), Gen.room_type(id: 2)]
      @hotel.stubs(:room_types).returns @room_types
      
      @inventory = [Gen.inventory(room_type_id: @room_types[0].id), Gen.inventory(room_type_id: @room_types[1].id)]
      @hotel.stubs(:inventories).returns @inventory
      
      @bookings = [Gen.booking(room_type_id: @room_types[0].id), Gen.booking(room_type_id: @room_types[1].id)]
      @hotel.stubs(:bookings).returns @bookings
      params = {date: "2013-03-13"}
      @context = Context.new params: params, hotel: @hotel
    end

    should "have the proper data" do
      l = list.run
      assert_equal 2, l.size
      [0,1].each do |i|
        assert_equal @room_types[i].name, l[i].name
        assert_equal @inventory[i].available_rooms, l[i].available
        assert_equal @inventory[i].sales_count, l[i].booked
        assert_equal percentage(@inventory[i]), l[i].percent_booked
        assert_equal [@bookings[i]], l[i].rooms
      end
    end
  end
  
end
