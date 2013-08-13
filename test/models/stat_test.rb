require "test_helper"

class StatTest < MiniTest::Should::TestCase
  
  
  def context
    @context ||= Context.new hotel: Gen.hotel, user: Gen.user, device_type: @device_type, user_bug: "asdfasdfas", params: {}
  end
  
  context "creating stats" do
    setup do
    end

    should "page" do
      assert_difference "Stat.count" do
        Stat.page context: context, url: "http://blah"
      end
    end

    should "search" do
      assert_difference "Stat.count" do
        Stat.search context: context, available_rooms: {}, dates: Date.today..Date.today
      end
    end

    should "look" do
      assert_difference "Stat.count" do
        Stat.look context: context
      end
    end

    should "book" do
      assert_difference "Stat.count" do
        Stat.book context: context
      end
    end

  end
  
  
  
end
