require 'test_helper'

class Inventory::CreateTest < ActiveSupport::TestCase


  def create
    @create ||= Inventory::Create.new context: @context
  end
  
  context "with valid parameters" do
    setup do
      @params = ActiveSupport::HashWithIndifferentAccess.new( {"hotel"=>{"start"=>"2013-06-26", "end"=>"2013-06-26", "inventories_attributes"=>{"0"=>{"room_type_id"=>"1", "available_rooms"=>"24", "rate"=>"50.0", "discounted_rate"=>"45.0"}, "1"=>{"room_type_id"=>"2", "available_rooms"=>"18", "rate"=>"65.0", "discounted_rate"=>"62.0"}, "2"=>{"room_type_id"=>"3", "available_rooms"=>"5", "rate"=>"75.0", "discounted_rate"=>""}}}})
      @hotel = Gen.hotel id: 7
      @context = Context.new hotel: @hotel, params: @params
    end

    should "convert them for proper use in Inventory::SyncWithRoomTypes" do
      assert_equal Date.new(2013,6,26)..Date.new(2013, 6,26), create.send(:range)
      assert_equal @params[:hotel][:inventories_attributes].map{|k,v| v}, create.send(:inventory_params)
      assert_equal Inventory::FakeHotel.new(@hotel.id).id, create.hotel.id
    end
    
  end
    
  
end