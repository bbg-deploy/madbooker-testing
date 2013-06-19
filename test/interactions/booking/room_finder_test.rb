require 'test_helper'

class Booking::RoomFinderTest < MiniTest::Should::TestCase


  def room_finder
    @room_finder ||= Booking::RoomFinder.new context: @context
  end
  
  context "checking for rooms" do
    setup do
      @r = [Gen.room_type(id: 1), Gen.room_type(id: 2)]
      @r.stubs(:all).returns @r
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
        @context.hotel.stubs(:room_types).returns @r
      end

      should "return an empty array" do
        res = room_finder.run
        assert_equal [], res.object
        assert res.error?        
      end
    end
    
    
    context "with inventories and with room_types but not overlapping dates" do
      setup do
        i = [Gen.inventory(date: Date.today, room_type_id: @r[0].id), Gen.inventory(date: Date.today-1, room_type_id: @r[1].id) ]
        room_finder.stubs(:inventories).returns i
        @context.hotel.stubs(:room_types).returns @r
      end

      should "return an empty array" do
        res = room_finder.run
        assert_equal [], res.object
        assert res.error?        
      end
    end
    
    
    
    context "with an inventory that overlaps only part of the dates" do
      setup do
        i = [Gen.inventory(date: Date.parse("2013-03-15"), room_type_id: @r[0].id), Gen.inventory(date: Date.today-1, room_type_id: @r[1].id) ]
        room_finder.stubs(:inventories).returns i
        @context.hotel.stubs(:room_types).returns @r
      end

      should "return an empty array" do
        res = room_finder.run
        assert_equal [], res.object
        assert res.error?        
      end
    end
    
    
    context "with an inventory inside dates" do
      setup do
        i = [
            Gen.inventory(date: Date.parse("2013-03-14"), room_type_id: @r[0].id),
            Gen.inventory(date: Date.parse("2013-03-15"), room_type_id: @r[0].id), 
            Gen.inventory(date: Date.parse("2013-03-15"), room_type_id: @r[1].id)
          ]
        room_finder.stubs(:inventories).returns i
        @context.hotel.stubs(:room_types).returns @r
      end

      should "return an empty array" do
        room_finder.expects(:room_types).with( [@r[0].id]).returns [@r[0]]
        res = room_finder.run
        assert_equal [@r[0]], res.object
        assert res.success?        
      end
    end
    
    context "with an inventory around dates" do
      setup do
        i = [
            Gen.inventory(date: Date.parse("2013-03-13"), room_type_id: @r[0].id),
            Gen.inventory(date: Date.parse("2013-03-14"), room_type_id: @r[0].id),
            Gen.inventory(date: Date.parse("2013-03-15"), room_type_id: @r[0].id),
            Gen.inventory(date: Date.parse("2013-03-16"), room_type_id: @r[0].id)
          ]
        room_finder.stubs(:inventories).returns i
        @context.hotel.stubs(:room_types).returns @r
      end

      should "return an empty array" do
        room_finder.expects(:room_types).with( [@r[0].id]).returns [@r[0]]
        res = room_finder.run
        assert_equal [@r[0]], res.object
        assert res.success?        
      end
    end
    
    
    context "with inventories inside dates" do
      setup do
        i = [
            Gen.inventory(date: Date.parse("2013-03-14"), room_type_id: @r[0].id),
            Gen.inventory(date: Date.parse("2013-03-15"), room_type_id: @r[0].id), 
            Gen.inventory(date: Date.parse("2013-03-14"), room_type_id: @r[1].id),
            Gen.inventory(date: Date.parse("2013-03-15"), room_type_id: @r[1].id)
          ]
        room_finder.stubs(:inventories).returns i
        @context.hotel.stubs(:room_types).returns @r
      end

      should "return an empty array" do
        room_finder.expects(:room_types).with( @r.map &:id).returns @r
        res = room_finder.run
        assert_equal @r, res.object
        assert res.success?        
      end
    end
    
    context "with an inventory around dates" do
      setup do
        i = [
            Gen.inventory(date: Date.parse("2013-03-13"), room_type_id: @r[0].id),
            Gen.inventory(date: Date.parse("2013-03-14"), room_type_id: @r[0].id),
            Gen.inventory(date: Date.parse("2013-03-15"), room_type_id: @r[0].id),
            Gen.inventory(date: Date.parse("2013-03-16"), room_type_id: @r[0].id),
            Gen.inventory(date: Date.parse("2013-03-13"), room_type_id: @r[1].id),
            Gen.inventory(date: Date.parse("2013-03-14"), room_type_id: @r[1].id),
            Gen.inventory(date: Date.parse("2013-03-15"), room_type_id: @r[1].id),
            Gen.inventory(date: Date.parse("2013-03-16"), room_type_id: @r[1].id)
          ]
        room_finder.stubs(:inventories).returns i
        @context.hotel.stubs(:room_types).returns @r
      end

      should "return an empty array" do
        room_finder.expects(:room_types).with( @r.map &:id).returns @r
        res = room_finder.run
        assert_equal @r, res.object
        assert res.success?        
      end
    end
    
    
  end
  
  
  
  
end