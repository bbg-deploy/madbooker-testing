require 'test_helper'



class Inventory::FormTest < MiniTest::Should::TestCase

  def form
    @form ||= Inventory::Form.new context: @context
  end
  
  
  context "an inventory form" do
    setup do
      params = {start: "2013-03-14", end: "2013-03-17"}
      @context = Context.new params:  params, hotel: Gen.hotel
      @r = [Gen.room_type(id: 1), Gen.room_type(id: 2)]
      @context.hotel.stubs(:room_types).returns @r
    end
    
    should "return the proper range" do
      assert_equal( (Date.parse("2013-03-14")..Date.parse("2013-03-17")), form.range)
    end
    
    should "return a hotel" do
      assert( form.hotel.class.name.to_s =~ /Hotel/)
    end
    
    context "with no inventories and no room_rates" do
      #this only happens if they don't create room_types before going to the inventory page
      setup do
        form.context.hotel.stubs(:room_types).returns []
        form.stubs(:inventories).returns []
      end

      should "return an empty array" do
        assert_equal [], form.run.hotel.inventories
      end
    end
    
    context "with no inventories in the range" do
      setup do
        form.stubs(:inventories).returns @i
        @form = form.run
      end

      should "return default values" do
        assert_equal 2, @form.hotel.inventories.size
        @r.each do |rt|
          i = form.hotel.inventories.select {|i| i.room_type_id == rt.id}.first          
          assert_equal rt.number_of_rooms, i.available_rooms
          assert_equal rt.default_rate, i.rate
          assert_equal rt.discounted_rate, i.discounted_rate
        end
      end
    end
    
    context "with matching inventories in the range" do
      setup do
        @i = []
        @i << Gen.inventory(date: Date.new(2013,3,14), room_type_id: 1)
        @i << Gen.inventory(date: Date.new(2013,3,15), room_type_id: 2)
        form.stubs(:inventories).returns @i
        @form = form.run
      end

      should "return existing values" do
        assert_equal 2, form.hotel.inventories.size
        @i.each do |i|
          j = form.run.hotel.inventories.select{|ii| i.room_type_id == ii.room_type_id}.first
          assert_equal i.available_rooms, j.available_rooms
          assert_equal i.rate, j.rate
          assert_equal i.discounted_rate, j.discounted_rate
        end
      end
    end
    
    context "with unmatching inventories in the range with the same room_type_id" do
      setup do
        @i = []
        @i << Gen.inventory(date: Date.new(2013,3,14), room_type_id: 1, available_rooms: @r[0].number_of_rooms+1, rate: @r[0].default_rate+1, discounted_rate: @r[0].discounted_rate+1)
        @i << Gen.inventory(date: Date.new(2013,3,15), room_type_id: 2, available_rooms: @r[1].number_of_rooms+1, rate: @r[1].default_rate+1, discounted_rate: @r[1].discounted_rate+1)
        form.stubs(:inventories).returns @i
        @form = form.run
      end

      should "return existing values" do
        assert_equal 2, form.hotel.inventories.size
        @i.each do |i|
          j = form.run.hotel.inventories.select{|ii| i.room_type_id == ii.room_type_id}.first
          assert_equal i.available_rooms, j.available_rooms
          assert_equal i.rate, j.rate
          assert_equal i.discounted_rate, j.discounted_rate
        end
      end
    end
    
    context "with mixed values inventories in the range with the same room_type" do
      setup do
        @i = []
        @i << Gen.inventory(date: Date.new(2013,3,14), room_type_id: 1, available_rooms: @r[0].number_of_rooms+1, rate: @r[0].default_rate+1, discounted_rate: @r[0].discounted_rate+1)
        @i << Gen.inventory(date: Date.new(2013,3,15), room_type_id: 1, available_rooms: @r[0].number_of_rooms+2, rate: @r[0].default_rate+2, discounted_rate: @r[0].discounted_rate+2)
        form.stubs(:inventories).returns @i
        @form = form.run
      end

      should "return existing values" do
        assert_equal 2, form.hotel.inventories.size
        @r.each do |rt|
          i = form.hotel.inventories.select {|i| i.room_type_id == rt.id}.first          
          assert_equal rt.number_of_rooms, i.available_rooms
          assert_equal rt.default_rate, i.rate
          assert_equal rt.discounted_rate, i.discounted_rate
        end
      end
    end
    
    
    
  end
  


  
end
