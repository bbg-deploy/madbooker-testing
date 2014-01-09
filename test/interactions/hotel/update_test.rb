require 'test_helper'

class Hotel::UpdateTest < ActiveSupport::TestCase


  def update
    @update ||= Hotel::Update.new context: @context
  end
    
  context "a hotel" do   
    teardown do
      Timecop.return
    end
    setup do
      Timecop.freeze Date.new(2013,1,1)
      hotel_attr = Gen.hotel.attributes.with_indifferent_access
      [:created_at, :updated_at, :id ,:owner_id].each {|s| hotel_attr.delete s}
      @params = {hotel: hotel_attr}
      @params[:hotel][:room_types_attributes] = {}
      0.upto(1) do |i|
        rt = Gen.room_type.attributes.with_indifferent_access
        %w(created_at updated_at hotel_id id).each {|s| rt.delete s}
        @params[:hotel][:room_types_attributes][i] = rt
      end
      Inventory.delete_all
      @hotel = Hotel::Create.new(Context.new(user: Gen.user(id: 7), params: @params, hotel: nil)).run
      #we now have hotel, room_types, and inventories. all this is tested in Hotel::CreateTest
    end
    
    context "update a hotel" do
      setup do
        #send the same params, unchanged
        @params[:hotel][:room_types_attributes][0][:id] = @hotel.room_types[0].id
        @params[:hotel][:room_types_attributes][1][:id] = @hotel.room_types[1].id
        @context = Context.new(user: Gen.user(id: 7), params: @params, hotel: @hotel)
      end
    
      should "nothing changes" do
        h_attr = @hotel.attributes
        rt = @hotel.room_types
        hotel = nil
        assert_no_difference "Hotel.count" do
        assert_no_difference "RoomType.count" do
        assert_no_difference "Inventory.count" do
          hotel = update.run.object
        end
        end
        end
        assert_equal h_attr, hotel.attributes
        assert_equal rt, hotel.reload.room_types
      end
    end
    
    context "update a room_type" do
      setup do
        @params[:hotel][:room_types_attributes][0][:id] = @hotel.room_types[0].id
        @params[:hotel][:room_types_attributes][1][:id] = @hotel.room_types[1].id
        @params[:hotel][:room_types_attributes][0][:default_rate] = 12.33
        @context = Context.new(user: Gen.user(id: 7), params: @params, hotel: @hotel)
      end
    
      should "nothing changes" do
        h_attr = @hotel.attributes
        rt = @hotel.room_types
        hotel = nil
        assert_no_difference "Hotel.count" do
        assert_no_difference "RoomType.count" do
        assert_no_difference "Inventory.count" do
          hotel = update.run.object
        end
        end
        end
        assert_equal h_attr, hotel.attributes
        assert_equal rt, hotel.reload.room_types
      end
    end
    
    context "removes a new room_type" do
      setup do
        @params[:hotel][:room_types_attributes][0][:id] = @hotel.room_types[0].id
        @params[:hotel][:room_types_attributes][1][:id] = @hotel.room_types[1].id
        @params[:hotel][:room_types_attributes][0][:_destroy] = true
        @context = Context.new(user: Gen.user(id: 7), params: @params, hotel: @hotel)
      end

      should "delete inventories for the room type" do
        h_attr = @hotel.attributes
        rt = @hotel.room_types
        inv_count = Inventory.count
        hotel = nil
        assert_no_difference "Hotel.count" do
        assert_difference "RoomType.count", -1 do
        assert_difference "Inventory.count", -(inv_count / 2) do
          hotel = update.run.object
        end
        end
        end
        assert_equal h_attr, hotel.attributes
        assert_equal rt, hotel.reload.room_types
      end
    end
    
    context "removes a new room_type that has bookings" do
      setup do
        Gen.booking! hotel_id: @hotel.id, bookable_id: @hotel.room_types[0].id, bookable_type: "RoomType"
        @params[:hotel][:room_types_attributes][0][:id] = @hotel.room_types[0].id
        @params[:hotel][:room_types_attributes][1][:id] = @hotel.room_types[1].id
        @params[:hotel][:room_types_attributes][0][:_destroy] = "true"
        @context = Context.new(user: Gen.user(id: 7), params: @params, hotel: @hotel)
      end

      should "not delete the room type" do
        h_attr = @hotel.attributes
        rt = @hotel.room_types
        book_count = Booking.count
        hotel = nil
        assert_no_difference "Hotel.count" do
        assert_no_difference "RoomType.count" do
        assert_no_difference "Booking.count" do
          hotel = update.run.object
        end
        end
        end
        assert_equal 1, hotel.errors.size
        assert_equal "You can not delete a room type that has bookings.", hotel.errors.messages.values.join
        assert_equal h_attr, hotel.attributes
        assert_equal rt, hotel.reload.room_types
      end
    end
    
    context "removes all room_types" do
      setup do
        @params[:hotel][:room_types_attributes][0][:_destroy] = true
        @params[:hotel][:room_types_attributes][1][:_destroy] = true
        @params[:hotel][:room_types_attributes][0][:id] = @hotel.room_types[0].id
        @params[:hotel][:room_types_attributes][1][:id] = @hotel.room_types[1].id
        @context = Context.new(user: Gen.user(id: 7), params: @params, hotel: @hotel)
      end
    
      should "don't change anything and return error" do
        h_attr = @hotel.attributes
        rt = @hotel.room_types
        hotel = nil
        assert_no_difference "Hotel.count" do
        assert_no_difference "RoomType.count" do
        assert_no_difference "Inventory.count" do
          hotel = update.run.object
        end
        end
        end
        assert_equal h_attr, hotel.attributes
        assert_equal rt, hotel.room_types
        assert !hotel.errors.blank?
        assert_equal "You must have at least one room type.", hotel.errors.messages.values.join
      end
    end
    
    
    context "adds a new room_type same day as hotel create" do
      setup do
        @params[:hotel][:room_types_attributes][0][:id] = @hotel.room_types[0].id
        @params[:hotel][:room_types_attributes][1][:id] = @hotel.room_types[1].id
        
        rt = Gen.room_type.attributes
        %w(created_at updated_at hotel_id).each {|s| rt.delete s}
        @params[:hotel][:room_types_attributes][2] = rt
        @context = Context.new(user: Gen.user(id: 7), params: @params, hotel: @hotel)
      end
    
      should "create inventories for the new room type" do
        h_attr = @hotel.attributes
        rt = @hotel.room_types
        inv_count = Inventory.count
        hotel = nil
        assert_no_difference "Hotel.count" do
        assert_difference "RoomType.count", 1 do
        assert_difference "Inventory.count", (inv_count /2) do
          hotel = update.run.object
        end
        end
        end
        assert_equal h_attr, hotel.attributes
      end
    end
    
        
    context "adds a new room_type in the future" do
      setup do
        @params[:hotel][:room_types_attributes][0][:id] = @hotel.room_types[0].id
        @params[:hotel][:room_types_attributes][1][:id] = @hotel.room_types[1].id
        
        Timecop.travel Date.new(2014,1,1)
        rt = Gen.room_type.attributes
        %w(created_at updated_at hotel_id).each {|s| rt.delete s}
        @params[:hotel][:room_types_attributes][2] = rt
        @context = Context.new(user: Gen.user(id: 7), params: @params, hotel: @hotel)
      end
    
      should "create inventories for the new room type" do
        h_attr = @hotel.attributes
        rt = @hotel.room_types
        inv_count = Inventory.count
        new_inv_count = (inv_count /4)
          # 4 cuz it should only add for the dates going forward
          # 2 rooms * 2 years = 4.
          # Add 1 new room should only add that fourth
        hotel = nil
        assert_no_difference "Hotel.count" do
        assert_difference "RoomType.count" do
        assert_difference "Inventory.count", new_inv_count do
          hotel = update.run.object
        end
        end
        end
        assert_equal h_attr, hotel.attributes
        assert_equal rt, hotel.reload.room_types
      end
    end
    

    
    
  end
  
end