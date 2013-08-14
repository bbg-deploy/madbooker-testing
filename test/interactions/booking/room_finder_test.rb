require 'test_helper'

class Booking::RoomFinderTest < ActiveSupport::TestCase


  def room_finder
    @room_finder ||= Booking::RoomFinder.new context: @context
  end
  
  context "averaging room prices" do
    setup do
      params = {:booking => {:arrive => "2013-03-13", :depart => "2013-03-17"}}
      @context = Context.new params: params, hotel: Gen.hotel
      @i = [
          Gen.inventory(date: Date.parse("2013-03-13"), discounted_rate: nil, rate: 10, room_type_id: 1),
          Gen.inventory(date: Date.parse("2013-03-14"), discounted_rate: 10, rate: 15, room_type_id: 1),
          Gen.inventory(date: Date.parse("2013-03-15"), discounted_rate: 15, rate: 20, room_type_id: 1), 
          Gen.inventory(date: Date.parse("2013-03-16"), discounted_rate: 20, rate: 25, room_type_id: 1)
        ]
      room_finder.stubs(:inventories).returns @i
    end

    should "return the average" do
      res = room_finder.run
      assert_equal 1,     res.available_rooms.size
      assert_equal 17.5,  res.available_rooms.first.rate
      assert_equal 13.75, res.available_rooms.first.discounted_rate
    end
  end
  
  
  context "checking for rooms" do
    setup do
      #booking only for 1 night
      params = {:booking => {:arrive => "2013-03-14", :depart => "2013-03-15"}}
      @context = Context.new params: params, hotel: Gen.hotel
    end
    
    context "with no inventories or room_types" do
      should "return an empty array" do
        res = room_finder.run
        assert_equal [], res.available_rooms
        assert_equal( {}, res.all_rooms)
      end
    end
    
    context "with no inventories but with room_types" do
      setup do
        room_finder.stubs(:inventories).returns []
      end

      should "return an empty array" do
        res = room_finder.run
        assert_equal [], res.available_rooms
        assert_equal( {}, res.all_rooms)
      end
    end
    
    
    context "with inventories and with room_types but not overlapping dates" do
      setup do
        i = [Gen.inventory(date: Date.today, room_type_id: 1), Gen.inventory(date: Date.today-1, room_type_id: 2) ]
        room_finder.stubs(:inventories).returns i
      end

      should "return an empty array" do
        res = room_finder.run
        assert_equal [], res.available_rooms
        assert_equal( {}, res.all_rooms)
      end
    end
    
    
    
    context "with an inventory that overlaps only the departure date" do
      setup do
        i = [Gen.inventory(date: Date.parse("2013-03-15"), room_type_id:1) ]
        room_finder.stubs(:inventories).returns i
      end

      should "return an empty array" do
        res = room_finder.run
        assert_equal [], res.available_rooms
        assert_equal( {}, res.all_rooms)
      end
    end
    
    
    context "with an inventory matching arrival and departure dates" do
      setup do
        @i = [
            Gen.inventory(date: Date.parse("2013-03-14"), room_type_id: 1, rate: 5, discounted_rate: nil),
            Gen.inventory(date: Date.parse("2013-03-15"), room_type_id: 1, rate: 5, discounted_rate: nil), 
            Gen.inventory(date: Date.parse("2013-03-15"), room_type_id: 2)
          ]
        room_finder.stubs(:inventories).returns @i
      end

      should "return a room" do
        res = room_finder.run
        assert_equal [@i[0]], res.available_rooms
        assert_equal( {1 => [@i[0], @i[1]]}, res.all_rooms)
      end
    end
    
    
    context "with an inventory matching arrival and departure dates but no availability on one date" do
      setup do
        hotel = Gen.hotel!
        @i = [
            Gen.inventory!(hotel_id: hotel.id, date: Date.parse("2013-03-14"), room_type_id: 1, available_rooms: 5, sales_count: 5),
            Gen.inventory!(hotel_id: hotel.id, date: Date.parse("2013-03-15"), room_type_id: 1, available_rooms: 0), 
            Gen.inventory!(hotel_id: hotel.id, date: Date.parse("2013-03-15"), room_type_id: 2)
          ]
        params = {:booking => {:arrive => "2013-03-14", :depart => "2013-03-16"}}
        @context = Context.new params: params, hotel: hotel
      end
    
      should "return an empty array" do
        res = room_finder.run
        assert_equal [], res.available_rooms
      end
    end
    
    
    context "with an inventory matching only the arrival date dates" do
      setup do
        @i = [
            Gen.inventory(date: Date.parse("2013-03-14"), room_type_id: 1),
            Gen.inventory(date: Date.parse("2013-03-15"), room_type_id: 2)
          ]
        room_finder.stubs(:inventories).returns @i
      end

      should "return an room" do
        res = room_finder.run
        assert_equal [@i[0]], res.available_rooms
      end
    end
    
    context "with an inventory around dates" do
      setup do
        @i = [
            Gen.inventory(date: Date.parse("2013-03-14"), room_type_id: 1, rate: 5, discounted_rate: nil),
            Gen.inventory(date: Date.parse("2013-03-15"), room_type_id: 1, rate: 5, discounted_rate: nil),
            Gen.inventory(date: Date.parse("2013-03-16"), room_type_id: 1, rate: 5, discounted_rate: nil)
          ]
        room_finder.stubs(:inventories).returns @i
      end

      should "return the arrival date" do
        res = room_finder.run
        assert_equal [@i[0]], res.available_rooms
      end
    end
    
    
    context "with inventories inside dates" do
      setup do
        @i = [
            Gen.inventory(date: Date.parse("2013-03-14"), room_type_id: 1, rate: 5, discounted_rate: nil),
            Gen.inventory(date: Date.parse("2013-03-15"), room_type_id: 1, rate: 5, discounted_rate: nil), 
            Gen.inventory(date: Date.parse("2013-03-14"), room_type_id: 2, rate: 5, discounted_rate: nil),
            Gen.inventory(date: Date.parse("2013-03-15"), room_type_id: 2, rate: 5, discounted_rate: nil)
          ]
        room_finder.stubs(:inventories).returns @i
      end

      should "return inventories" do
        res = room_finder.run
        assert_equal [@i[0], @i[2]], res.available_rooms
      end
    end
    
    
    
  end
  
  
  
  
end