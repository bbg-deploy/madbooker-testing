require 'test_helper'

class Inventory::SyncWithRoomTypesTest < MiniTest::Should::TestCase
  
  def sync
    return @sync ||= Inventory::SyncWithRoomTypes.new( @context, raises: @raises, range: @range)
  end

  context "a hotel create" do
    setup do
      Timecop.freeze Date.new(2013,1,1)
      @hotel = Gen.hotel!
      @params = []
      0.upto(1) do |i|
        rt = Gen.inventory.attributes
        %w(created_at updated_at hotel_id).each {|s| rt.delete s}
        @params << rt
      end
      Inventory.delete_all
      RoomType.delete_all
      @context = Context.new(user: Gen.user(id: 7), params: @params, hotel: @hotel)
      @raises = true
      @range = Date.current..(Date.current.advance( years: 2) - 1)
    end

  
    context "with valid hotel & room_type parameters" do
      setup do
      end

      should "create 2 years of inventories" do
        assert_difference "Inventory.count", 1460 do #365 * 2 (years) * 2 (room types)
          sync.run
        end
      end
    end
  
    context "with valid hotel & not valid room_type parameters" do
      setup do        
        @params.each do |attributes_hash|
          attributes_hash.delete "rate"
        end
        @context = Context.new(user: Gen.user(id: 7), params: @params, hotel: @hotel)
      end

      should "create nothing" do
        assert_no_difference "Inventory.count" do
        assert_raises ActiveRecord::RecordInvalid do
          sync.run
        end
        end
      end
    end   
  end  
  
  context "an inventory create" do
    setup do
      Inventory.delete_all
      Timecop.freeze Date.new(2013,1,1)
      @hotel =  Gen.hotel!
      @params = [
        {"room_type_id"=>"1", "available_rooms"=>"666", "rate"=>"50.0", "discounted_rate"=>"45.0"},
        {"room_type_id"=>"2", "available_rooms"=>"666", "rate"=>"65.0", "discounted_rate"=>"62.0"},
        {"room_type_id"=>"3", "available_rooms"=>"666", "rate"=>"75.0", "discounted_rate"=>""}
        ]

      @context = Context.new(user: Gen.user(id: 7), params: @params, hotel: Inventory::FakeHotel.new(@hotel.id))
      @raises = false
      @range = Date.new(2013, 06,26)..Date.new(2013,06,26)
    end

  
  
    context "with valid parameters" do
      setup do
      end

      should "create" do
        res = nil
        assert_difference "Inventory.count", 3 do
          res = sync.run
        end
        assert res.success?
      end
    
      context "and existing inventories" do
        setup do
          @inv = []
          1.upto 3 do |i|
            @inv << Gen.inventory!( room_type_id: i, available_rooms: 665, hotel_id: @hotel.id, date: Date.parse("2013-06-26"))
          end
        end

        should "update existings" do
          res = nil
          assert_difference "@inv[0].reload.available_rooms" do
          assert_difference "@inv[1].reload.available_rooms" do
          assert_difference "@inv[2].reload.available_rooms" do
          assert_no_difference "Inventory.count" do
            res = sync.run
          end
          end
          end
          end
        assert res.success?
        end
      end
    
    end
  
  
    context "with invalid parameters" do
      setup do
        @params.each {|hash| hash.delete "available_rooms"}
        @context = Context.new(user: Gen.user(id: 7), params: @params, hotel:  Inventory::FakeHotel.new(@hotel.id))
      end
    
      should "not create" do
        res = nil
        assert_no_difference "Inventory.count" do
          res = sync.run
        end
        assert res.error?
      end
    
      context "and existing inventories" do
        setup do
          @inv = []
          1.upto 3 do |i|
            @inv << Gen.inventory!( room_type_id: i, available_rooms: 665, hotel_id: @hotel.id, date: Date.parse("2013-06-26"))
          end
        end
    
        should "not create and don't update" do
          res = nil
          assert_no_difference "@inv[0].reload.available_rooms" do
          assert_no_difference "@inv[1].reload.available_rooms" do
          assert_no_difference "@inv[2].reload.available_rooms" do
          assert_no_difference "Inventory.count" do
            res = sync.run
          end
          end
          end
          end
          assert res.error?
        end
      end
    end
  end

end