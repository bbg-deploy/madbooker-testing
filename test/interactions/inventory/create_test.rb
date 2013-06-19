require 'test_helper'

class Inventory::CreateTest < MiniTest::Should::TestCase


  def create
    @create ||= Inventory::Create.new context: @context
  end
  
  context "with valid parameters" do
    setup do
      params = ActiveSupport::HashWithIndifferentAccess.new( {"hotel"=>{"start"=>"2013-06-26", "end"=>"2013-06-26", "inventories_attributes"=>{"0"=>{"room_type_id"=>"1", "available_rooms"=>"24", "rate"=>"50.0", "discounted_rate"=>"45.0"}, "1"=>{"room_type_id"=>"2", "available_rooms"=>"18", "rate"=>"65.0", "discounted_rate"=>"62.0"}, "2"=>{"room_type_id"=>"3", "available_rooms"=>"5", "rate"=>"75.0", "discounted_rate"=>""}}}})
      @hotel = Gen.hotel!
      @context = Context.new hotel: @hotel, params: params
    end

    should "create" do
      res = nil
      assert_difference "Inventory.count", 3 do
        res = create.run
      end
      assert res.success?
    end
    
    context "and existing inventories" do
      setup do
        1.upto 3 do |i|
          Gen.inventory! hotel_id: @hotel.id, date: Date.parse("2013-06-26")
        end
      end

      should "create and delete" do
        res = nil
        inv_ids = @hotel.inventory_ids
        assert_no_difference "Inventory.count" do
          res = create.run
        end
        assert_equal 3, inv_ids.size
        assert inv_ids != @hotel.reload.inventory_ids
      assert res.success?
      end
    end
    
  end
  
  context "with invalid parameters" do
    setup do
      params = ActiveSupport::HashWithIndifferentAccess.new( {"hotel"=>{"start"=>"2013-06-26", "end"=>"2013-06-26", "inventories_attributes"=>{"0"=>{"room_type_id"=>"", "available_rooms"=>"24", "rate"=>"50.0", "discounted_rate"=>"45.0"}, "1"=>{"room_type_id"=>"", "available_rooms"=>"18", "rate"=>"65.0", "discounted_rate"=>"62.0"}, "2"=>{"room_type_id"=>"", "available_rooms"=>"5", "rate"=>"75.0", "discounted_rate"=>""}}}})
      @hotel = Gen.hotel!
      @context = Context.new hotel: @hotel, params: params
    end

    should "not create" do
      res = nil
      assert_no_difference "Inventory.count" do
        res = create.run
      end
      assert res.error?
    end
    
    context "and existing inventories" do
      setup do
        1.upto 3 do |i|
          Gen.inventory! hotel_id: @hotel.id, date: Date.parse("2013-06-26")
        end
      end

      should "not create and don't delete" do
        inv_ids = @hotel.inventory_ids
        res = nil
        assert_no_difference "Inventory.count" do
          res = create.run
        end
        assert_equal 3, inv_ids.size
        assert_equal @hotel.reload.inventory_ids, inv_ids
        assert res.error?
      end
    end
  end
  
  
  
  
  
end