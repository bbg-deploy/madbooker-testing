require 'test_helper'

class Booking::RoomFinderTest < MiniTest::Should::TestCase


  def room_finder
    @room_finder ||= Booking::RoomFinder.new context: @context
  end
  
  context "checking for rooms" do
    setup do
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
    
    
    
    context "with an inventory that overlaps only part of the dates" do
      setup do
        i = [Gen.inventory(date: Date.parse("2013-03-15"), room_type_id:1), Gen.inventory(date: Date.today-1, room_type_id: 2) ]
        room_finder.stubs(:inventories).returns i
      end

      should "return an empty array" do
        res = room_finder.run
        assert_equal [], res.object
        assert res.error?        
      end
    end
    
    
    context "with an inventory inside dates" do
      setup do
        @i = [
            Gen.inventory(date: Date.parse("2013-03-14"), room_type_id: 1),
            Gen.inventory(date: Date.parse("2013-03-15"), room_type_id: 1), 
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
            Gen.inventory(date: Date.parse("2013-03-13"), room_type_id: 1),
            Gen.inventory(date: Date.parse("2013-03-14"), room_type_id: 1),
            Gen.inventory(date: Date.parse("2013-03-15"), room_type_id: 1),
            Gen.inventory(date: Date.parse("2013-03-16"), room_type_id: 1)
          ]
        room_finder.stubs(:inventories).returns @i
      end

      should "return an empty array" do
        res = room_finder.run
        assert_equal [@i[0]], res.object
        assert res.success?        
      end
    end
    
    
    context "with inventories inside dates" do
      setup do
        @i = [
            Gen.inventory(date: Date.parse("2013-03-14"), room_type_id: 1),
            Gen.inventory(date: Date.parse("2013-03-15"), room_type_id: 1), 
            Gen.inventory(date: Date.parse("2013-03-14"), room_type_id: 2),
            Gen.inventory(date: Date.parse("2013-03-15"), room_type_id: 2)
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