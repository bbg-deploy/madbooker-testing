require 'test_helper'

class Inventory::FakeHotelTest < MiniTest::Should::TestCase

  context "a fake hotel" do
    
    setup do        
      @hotel = Inventory::FakeHotel.new 7
    end
    
    should "have a proper model name" do
      assert_equal ActiveModel::Name, @hotel.class.model_name.class
      assert_equal "Hotel", @hotel.class.model_name.name
    end
    
    should "return to_key properly" do
      assert_equal ["hotel"], @hotel.to_key
    end
        
    should "has the proper public interface" do
      assert @hotel.respond_to?( "inventories_attributes=")
      assert @hotel.respond_to?( "inventories=")
      assert @hotel.respond_to?( "inventories")
    end
    
    should "have the proper id" do
      assert_equal 7, @hotel.id
    end
    
  end
  
  
  
end