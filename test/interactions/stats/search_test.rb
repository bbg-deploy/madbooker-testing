require 'test_helper'

class Stats::SearchTest < MiniTest::Should::TestCase

  def search
    @search ||= Stats::Search.new context: @context, available_rooms: @available_rooms, user_bug: "user"
  end
  
  context "recording a search" do
    setup do
      @available_rooms = [
        Gen.inventory(room_type_id: 1),
        Gen.inventory(room_type_id: 2),
        Gen.inventory(room_type_id: 3)
        ]
      params = {:booking => {:arrive => "2013-03-13", :depart => "2013-03-17"}}
      @context = Context.new hotel: Gen.hotel, params: params
      Stat.any_instance.stubs(:save)
    end

    should "transform data and return a proper stat" do
      stat = search.run
      assert_equal [1,2,3], JSON.parse(stat.data).with_indifferent_access[:available_rooms]
      assert_equal Date.new(2013,3,13), stat.start
      assert_equal Date.new(2013,3,17), stat.end
    end
  end
  
  
  
    
end