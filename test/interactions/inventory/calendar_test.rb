require 'test_helper'

class Inventory::CalendarTest < MiniTest::Should::TestCase

  def calendar
    @calendar ||= Inventory::Calendar.new context: @context
  end
  
  context "running a calendar" do
    
    context "converts params to date" do
      setup do        
        params = {id: "2013"}
        @context = Context.new params:  params, hotel: nil
      end

      should "return proper date" do
        d = calendar.send :date
        assert_equal Date.new(2013), d
      end

    end
    
    context "converts invalid params to date" do
      setup do        
        params = {id: "asdf"}
        @context = Context.new params:  params, hotel: nil
      end

      should "return raise arg err" do
        #nothing raised
        assert calendar.send( :date)
      end

    end
    
    context "converts empty params to date" do
      setup do        
        params = {}
        @context = Context.new params:  params, hotel: nil
      end

      should "return today date" do
        d = calendar.send :date
        assert_equal Date.current, d
      end

    end
    
  end
  
  
  
end