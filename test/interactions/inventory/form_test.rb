require 'test_helper'



class Inventory::FormTest < MiniTest::Should::TestCase

  def form
    @form ||= Inventory::Form.new context: @context
  end
  
  context "running a form" do
    
    context "with no inventories" do
      setup do
        params = {year: "2013", month: "3"}
        @context = Context.new params:  params, hotel: Hotel.first
        @form = form.run
      end
      
      should "have a mini hotel " do
        p Hotel.all
        p RoomTypex.all
        p @form
      end
    end
    
  end
  
  
  
end