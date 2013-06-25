require 'test_helper'

class Booking::RoomFinderTest < MiniTest::Should::TestCase


  def room_finder
    @room_finder ||= Booking::RoomFinder.new context: @context
  end
  
  context "averaging room prices" do
    setup do
      params = {:booking => {:arrive => "2013-03-13", :depart => "2013-03-17"}}
      @context = Context.new params: params, hotel: Gen.hotel
      @i = [
          Gen.inventory(date: Date.parse("2013-03-12"), discounted_rate: 0, rate: 5, room_type_id: 1),
          Gen.inventory(date: Date.parse("2013-03-13"), discounted_rate: 5, rate: 10, room_type_id: 1),
          Gen.inventory(date: Date.parse("2013-03-14"), discounted_rate: 10, rate: 15, room_type_id: 1),
          Gen.inventory(date: Date.parse("2013-03-15"), discounted_rate: 15, rate: 20, room_type_id: 1), 
          Gen.inventory(date: Date.parse("2013-03-16"), discounted_rate: 20, rate: 25, room_type_id: 1), 
          Gen.inventory(date: Date.parse("2013-03-17"), discounted_rate: 25, rate: 30, room_type_id: 1)
        ]
      room_finder.stubs(:inventories).returns @i
    end

    should "return the average" do
      res = room_finder.run
      assert_equal 1,     res.object.size
      assert_equal 17.5, res.object.first.rate
      assert_equal 12.5,    res.object.first.discounted_rate
      assert res.success?        
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
        assert_equal [], res.object
        assert res.error?        
      end
    end
    
    context "with no inventories but with room_types" do
      setup do
        room_finder.stubs(:inventories).returns []
      end

      should "return an empty array" do
        res = room_finder.run
        assert_equal [], res.object
        assert res.error?        
      end
    end
    
    
    context "with inventories and with room_types but not overlapping dates" do
      setup do
        i = [Gen.inventory(date: Date.today, room_type_id: 1), Gen.inventory(date: Date.today-1, room_type_id: 2) ]
        room_finder.stubs(:inventories).returns i
      end

      should "return an empty array" do
        res = room_finder.run
        assert_equal [], res.object
        assert res.error?        
      end
    end
    
    
    
    context "with an inventory that overlaps only the departure date" do
      setup do
        i = [Gen.inventory(date: Date.parse("2013-03-15"), room_type_id:1) ]
        room_finder.stubs(:inventories).returns i
      end

      should "return an empty array" do
        res = room_finder.run
        assert_equal [], res.object
        assert res.error?        
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
        assert_equal [@i[0]], res.object
        assert res.success?        
      end
    end
    
    
    # This test requires activerecord and the database
    # context "with an inventory matching arrival and departure dates but no availability on one date" do
    #   setup do
    #     @i = [
    #         Gen.inventory(date: Date.parse("2013-03-14"), room_type_id: 1, available_rooms: 5, bookings_count: 5),
    #         Gen.inventory(date: Date.parse("2013-03-15"), room_type_id: 1), 
    #         Gen.inventory(date: Date.parse("2013-03-15"), room_type_id: 2)
    #       ]
    #     room_finder.stubs(:inventories).returns @i
    #   end
    # 
    #   should "return an empty array" do
    #     res = room_finder.run
    #     assert_equal [], res.object
    #     assert res.error?        
    #   end
    # end
    
    
    context "with an inventory matching only the arrival date dates" do
      setup do
        @i = [
            Gen.inventory(date: Date.parse("2013-03-14"), room_type_id: 1),
            Gen.inventory(date: Date.parse("2013-03-15"), room_type_id: 2)
          ]
        room_finder.stubs(:inventories).returns @i
      end

      should "return an empty array" do
        res = room_finder.run
        assert_equal [@i[0]], res.object
        assert res.success?        
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
        assert_equal [@i[0]], res.object
        assert res.success?        
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
        assert_equal [@i[0], @i[2]], res.object
        assert res.success?        
      end
    end
    
    
    
  end
  
  
  
  
end