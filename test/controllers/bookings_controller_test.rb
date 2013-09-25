require "test_helper"

class BookingsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  context "update with room type change" do
    setup do
      @user = Gen.user!
      @hotel = Gen.hotel! owner: @user
      @booking = Gen.booking! hotel_id: @hotel.id, id: 1
      @params = {"booking"=>{"arrive"=>"2013-09-19", "depart"=>"2013-10-16", "bookable"=>"R3", "first_name"=>"asdf", "last_name"=>"adsf", "email"=>"stevenbristol@gmail.com", "made_by_first_name"=>"", "made_by_last_name"=>"", "cc_number"=>"4242424242424242", "cc_month"=>"3", "cc_year"=>"2015", "cc_zipcode"=>"23", "cc_cvv"=>"123", "email_confirmation"=>"", "sms_confirmation"=>""}, "commit"=>"Save Changes", "hotel_id"=>@hotel.id, "id"=>@booking.id}
      @controller.stubs :current_user => @user
      @controller.stubs :current_hotel => @hotel
    end

    should "work fine" do
      sign_in @user
      put :update, @params
      assert_equal 3, assigns(:booking).bookable_id
    end
  end
  
  
end
