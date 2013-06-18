require 'test_helper'

class Inventory::CalendarTest < MiniTest::Should::TestCase

  def calendar
    @calendar ||= Inventory::Calendar.new context: @context
  end
  
  context "running a calendar" do
    
    context "converts params to date" do
      setup do        
        params = {year: "2013", month: "3"}
        @context = Context.new params:  params, hotel: nil
      end

      should "return proper date" do
        d = calendar.send :date
        assert_equal Date.new(2013,3,1), d
      end

    end
    
    context "converts invalid params to date" do
      setup do        
        params = {year: "0", month: "0"}
        @context = Context.new params:  params, hotel: nil
      end

      should "return raise arg err" do
        assert_raises ArgumentError do
          d = calendar.send :date
        end
      end

    end
    
    context "converts empty params to date" do
      setup do        
        params = {}
        @context = Context.new params:  params, hotel: nil
      end

      should "return today date" do
        d = calendar.send :date
        assert_equal Date.today, d
      end

    end
    
  end
  
  
  
end