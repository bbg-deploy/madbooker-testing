require 'test_helper'

class Hotel::CreateTest < ActiveSupport::TestCase


  def create
    @create ||= Hotel::Create.new context: @context
  end
  
  context "a hotel" do
    setup do
      Timecop.freeze Date.new(2013,1,1)
      hotel_attr = Gen.hotel.attributes
      [:created_at, :updated_at].each {|s| hotel_attr.delete s}
      @params = {hotel: hotel_attr}
      @params[:hotel][:room_types_attributes] = {}
      0.upto(1) do |i|
        rt = Gen.room_type.attributes
        %w(created_at updated_at hotel_id).each {|s| rt.delete s}
        @params[:hotel][:room_types_attributes][i] = rt
      end
    end

  
    context "with a non-valid hotel & valid room_type parameters" do
      setup do
        @params[:hotel][:email] = "sldfkj+2@sdlfj"
        @context = Context.new(user: Gen.user(id: 7), params: @params, hotel: nil)
      end

      should "not create anything" do
        assert_no_difference "Inventory.count" do
        assert_no_difference "Membership.count" do
        assert_no_difference "RoomType.count" do
        assert_no_difference "Hotel.count" do
          hotel = create.run
          assert_equal 1, hotel.errors.size
        end
        end
        end
        end
      end
    end
  
    context "with valid hotel & room_type parameters" do
      setup do
        @context = Context.new(user: Gen.user(id: 7), params: @params, hotel: nil)
      end

      should "create a hotel, two room types, and a shit ton of inventories and set the hotel owner" do
        assert_difference "Inventory.count", 1460 do #365 * 2 (years) * 2 (room types)
        assert_difference "Membership.count" do
        assert_difference "RoomType.count", 2 do
        assert_difference "Hotel.count" do
          hotel = create.run
          assert_equal 7, hotel.owner_id
        end
        end
        end
        end
      end
    end
  
    context "with valid hotel & not valid room_type parameters" do
      setup do        
        @params[:hotel][:room_types_attributes].each do |k, v|
          v.delete "default_rate"
        end
        @context = Context.new(user: Gen.user(id: 7), params: @params, hotel: nil)
      end

      should "create nothing" do
        assert_no_difference "Inventory.count" do
        assert_no_difference "Membership.count" do
        assert_no_difference "RoomType.count" do
        assert_no_difference "Hotel.count" do
          hotel = create.run
        end
        end
        end
        end
      end
    end 
  
  
    context "with valid hotel & no room_type parameters" do
      setup do        
        @params[:hotel].delete :room_types_attributes
        @context = Context.new(user: Gen.user(id: 7), params: @params, hotel: nil)
      end

      should "create nothing" do
        assert_no_difference "Inventory.count" do
        assert_no_difference "Membership.count" do
        assert_no_difference "RoomType.count" do
        assert_no_difference "Hotel.count" do
          hotel = create.run
        end
        end
        end
        end
      end
    end 
  end  
  
  
end