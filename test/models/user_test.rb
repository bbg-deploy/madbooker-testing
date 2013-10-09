require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  
  context "cleanup data" do
    setup do
      hotel_mine = Gen.hotel_and_stuff!
      @user = hotel_mine.owner
      hotel_other = Gen.hotel_and_stuff!
      Gen.membership! hotel_id: hotel_other.id, user_id: @user.id, email: @user.email
    end

    should "only delete business that I own" do
      assert_difference "Hotel.count", -1 do
      assert_difference "User.count", -1 do
      assert_difference "RoomType.count", -2 do
        @user.destroy
      end
      end
      end
    end
  end
  
  
  
end
