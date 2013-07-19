require 'test_helper'

class Hotel::RevenueByRoomTypeTest < MiniTest::Should::TestCase


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
  end
  
  def assert_values row, week, month, average
    assert_equal week, row.week
    assert_equal month, row.month
    assert_equal average, row.average
  end
  
  context "a hotel with no data" do
    setup do
      @packages = []
      @room_types = [Gen.room_type]
      @context = Context.new hotel: hotel
      #stub_data
    end
    should "return an empty set" do
      res = rev.run
      assert_equal 1, res.size
      assert_values res[0], 0, 0, 0
    end
  end
  
  context "a hotel with no sales" do
    setup do
      
    end

    should "description" do
      
    end
  end
  
  
  
end