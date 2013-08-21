require 'test_helper'



class Booking::ParamsWithRateTest < ActiveSupport::TestCase

  def params_with_rate
    @params_with_rate ||= Booking::ParamsWithRate.new(@context)
  end
  
  context "room type in params" do
    setup do
      @params = ActionController::Parameters.new "booking"=>{"bookable_id"=>"1", "bookable_type"=>"RoomType"}
      @context = Context.new params: @params
      params_with_rate.stubs(:available_rooms).returns([Gen.inventory(room_type_id: 1, rate: 20.0, discounted_rate: nil)])
    end
    

    should "find the right balances" do
      params = params_with_rate.run
      assert_equal 20.0, params[:rate]
      assert_equal nil, params[:discounted_rate]
    end
  end
  
  context "package in params" do
    setup do
      @params = ActionController::Parameters.new"booking"=>{"bookable_id"=>"1", "bookable_type"=>"Package"}
      hotel = mock
      hotel.stubs(:packages).returns(stub :find => Gen.package(additional_price: 1.0))
      @context = Context.new params: @params, hotel: hotel
      params_with_rate.stubs(:available_rooms).returns([Gen.inventory(room_type_id: 1, rate: 12.0, discounted_rate: 2.93)])
    end
    

    should "find the right balances" do
      params = params_with_rate.run
      assert_equal 13.0, params[:rate]
      assert_equal 3.93, params[:discounted_rate]
    end
  end
  
  
  
  
end