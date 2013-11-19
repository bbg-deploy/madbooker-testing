require 'test_helper'

class Hotel::RevenueByRoomTypeTest < ActiveSupport::TestCase


  def rev
    @rev ||= Hotel::RevenueByRoomType.new context: @context
  end
  
  def hotel
    return @hotel if @hotel
    @packages ||= []
    @room_types ||= []
    @hotel = Gen.hotel
    @hotel.stubs(:room_types).returns @room_types
    @hotel.stubs(:packages).returns(stub active: @packages)
    @hotel.stubs(:sales).returns([])
    @hotel
  end
  
  def assert_values row, week, month, average
    assert_equal week, row.week
    assert_equal month, row.month
    assert_equal average, row.average
  end
  
  context "a hotel with no packages or sales" do
    setup do
      @packages = []
      @room_types = [Gen.room_type(id: 2)]
      @get_data = []
      @context = Context.new hotel: hotel
      rev.stubs(:get_data).returns @get_data
    end
    should "return an empty set" do
      res = rev.run
      assert_equal 1, res.size
      assert_values res[0], 0, 0, 0
    end
  end
  
  context "a hotel with no sales" do
    setup do
      @packages = [Gen.package(id: 1)]
      @room_types = [Gen.room_type(id: 2)]
      @packages[0].stubs(:room_type).returns(@room_types[0])
      @get_data = []
      @context = Context.new hotel: hotel
      rev.stubs(:get_data).returns @get_data
    end
    should "return an empty set" do
      res = rev.run
      assert_equal 2, res.size
      assert_values res[0], 0, 0, 0
      assert_values res[1], 0, 0, 0
    end
  end
  
  context "a hotel with sales" do
    setup do
      @packages = [Gen.package(id: 1)]
      @room_types = [Gen.room_type(id: 2)]
      @packages[0].stubs(:room_type).returns(@room_types[0])
      @get_data = []
      @context = Context.new hotel: hotel
      rev.stubs(:get_data).with(Time.week, :sum).returns( {[2, "RoomType"]=>180.0, [1, "Package"]=>75.0})
      rev.stubs(:get_data).with(Time.month, :sum).returns( {[2, "RoomType"]=>181.0, [1, "Package"]=>76.0})
      rev.stubs(:get_data).with(Time.month, :average).returns( {[2, "RoomType"]=>182.0, [1, "Package"]=>77.0})
    end
    should "return good data" do
      res = rev.run
      assert_equal 2, res.size
      assert_values res[0], 180, 181, 182
      assert_values res[1], 75, 76, 77
    end
  end
  
  
  context "a hotel with sales but one room with no sales" do
    setup do
      @packages = [Gen.package(id: 1)]
      @room_types = [Gen.room_type(id: 2)]
      @packages[0].stubs(:room_type).returns(@room_types[0])
      @get_data = []
      @context = Context.new hotel: hotel
      rev.stubs(:get_data).with(Time.week, :sum).returns( {[2, "RoomType"]=>0, [1, "Package"]=>75.0})
      rev.stubs(:get_data).with(Time.month, :sum).returns( {[2, "RoomType"]=>0, [1, "Package"]=>76.0})
      rev.stubs(:get_data).with(Time.month, :average).returns( {[2, "RoomType"]=>0, [1, "Package"]=>77.0})
    end
    should "return good data" do
      res = rev.run
      assert_equal 2, res.size
      assert_values res[0], 0, 0, 0
      assert_values res[1], 75, 76, 77
    end
  end
  
  
  
end