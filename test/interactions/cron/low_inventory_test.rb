require 'test_helper'

class Cron::LowInventoryTest < ActiveSupport::TestCase


  def low_inventory
    @low_inventory ||= Cron::LowInventory.new nil
  end
  
  def setup_data threshold
    @h1 = Gen.hotel_and_stuff! minimal_inventory_notification_threshold: threshold
    @h2 = Gen.hotel_and_stuff! minimal_inventory_notification_threshold: threshold
  end
  
  def make_inventory room_type, date, available, sold
    room_type.inventories.create! date: date, hotel_id: room_type.hotel_id, rate: 1, available_rooms: available, sales_count: sold
  end

  context "with nothing to send" do
    setup do
      setup_data 1
      1.upto(30) do |i|
        make_inventory @h1.room_types.first, Date.current+i, 10, 1
        make_inventory @h1.room_types.last, Date.current+i, 10, 1
        make_inventory @h2.room_types.first, Date.current+i, 10, 1
        make_inventory @h2.room_types.last, Date.current+i, 10, 1
      end
      low_inventory.stubs(:send_emails).times(0)
    end
  
    should "send zero emails" do
      stats = low_inventory.run
      assert_equal 0, stats.hotels
      assert_equal 0, stats.inventories
      assert_equal [], stats.details
    end
  end
  
  context "with a 60 to send" do
    setup do
      setup_data 5
      1.upto(30) do |i|
        make_inventory @h1.room_types.first, Date.current+i, 10, 5
        make_inventory @h1.room_types.last, Date.current+i, 10, 5
        make_inventory @h2.room_types.first, Date.current+i, 10, 5
        make_inventory @h2.room_types.last, Date.current+i, 10, 5
      end      
    end
  
    should "send 1 to each hotel" do
      assert_difference "ActionMailer::Base.deliveries.size", 2 do
        stats = low_inventory.run
        assert_equal 2, stats.hotels
        # 2 hotels, 30 days, 2 room types
        assert_equal 120, stats.inventories
        assert !stats.details.blank?
      end
    end
  end
  
  context "with 60 to send and 60 not to send" do
    setup do
      setup_data 5
      1.upto(60) do |i|
        make_inventory @h1.room_types.first, Date.current+i, 10, 5
        make_inventory @h1.room_types.last, Date.current+i, 10, 5
        make_inventory @h2.room_types.first, Date.current+i, 10, 5
        make_inventory @h2.room_types.last, Date.current+i, 10, 5
      end
    end

    should "only send in this 30 days" do
      assert_difference "ActionMailer::Base.deliveries.size", 2 do
        stats = low_inventory.run
        assert_equal 2, stats.hotels
        # 2 hotels, 30 days, 2 room types
        assert_equal 120, stats.inventories
        assert !stats.details.blank?
      end
    end
  end
  
  
  
  
end