require 'test_helper'

class Inventory::CalendarTest < MiniTest::Should::TestCase

  def calendar
    @calendar ||= Inventory::Calendar.new context: @context
  end
  
  context "running a calendar" do
    
    context "with no inventories" do
      setup do
        params = {year: "2013", month: "3"}
        hotel = mock(inventories: mock(for_month: []))
        @context = Context.new params:  params, hotel: hotel
        @month = calendar.run
      end

      should "have no inventories" do
        assert_equal [], @month.inventories
      end
      
      should "have previous month set to feb" do
        assert_equal Date.new(2013, 02,01), @month.previous_month
      end
      
      should "have next month set to apr" do
        assert_equal Date.new(2013, 04,01), @month.next_month
      end
    end
    
  end
  
  
  
end