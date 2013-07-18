require 'test_helper'

class PackageDecoratorTest < MiniTest::Should::TestCase
  
  def decorated_package
    @decorated_package ||= @package.decorate.with_inventory @inventory
  end
  
  def set a,b,c,d,e
    room_type = Gen.room_type default_rate: a, discounted_rate: b
    @inventory = Gen.inventory rate: c, discounted_rate: d
    @package = Gen.package additional_price: e
    @inventory.stubs(:room_type).returns room_type
    @package.stubs(:room_type).returns room_type
  end
  
  context "the maths" do
    context "if room_type and inventory values are the same" do
      setup do
        set 40,20,40,20,12
      end
      should "return the rate from the package" do
        assert_equal 52, decorated_package.rate
        assert_equal 32, decorated_package.discounted_rate
      end
    end

    context "if inventory values are higher than the room_type values" do
      setup do
        set 40,20,50,30,12
      end
      should "return the offset increased rate from the package" do
        assert_equal 62, decorated_package.rate
        assert_equal 42, decorated_package.discounted_rate
      end
    end

    context "if inventory values are lower than the room_type values" do
      setup do
        set 40,20,30,10,12
      end
      should "return the offset decreased rate from the package" do
        assert_equal 42, decorated_package.rate
        assert_equal 22, decorated_package.discounted_rate
      end
    end
    
    context "if the discounted_rates are all nil" do
      setup do
        set 0,nil,0,nil,0
      end
      should "should return nil for discounted_rate" do
        assert_equal nil, decorated_package.discounted_rate
      end
    end
    #     
    # context "if the discounted_rate for the room_type is nil but not for the inventory or package" do
    #   setup do
    #     set 20,nil,30,20,0,30
    #   end
    #   should "should return the discounted_rate for the package" do
    #     assert_equal 20, decorated_package.discounted_rate
    #   end
    # end
    # 
    # context "if the discounted_rates are nil for the room_type and the package but not the inventory" do
    #   setup do
    #     set 40,nil,50,40,60,nil
    #   end
    #   should "should return the offset discounted_rate (offset based on rate) for the inventory" do
    #     assert_equal 50, decorated_package.discounted_rate
    #   end
    # end
    # 
    # context "if the discounted_rates are nil for the room_type and the package but not the inventory" do
    #   setup do
    #     set 50,nil,40,30,60,nil
    #   end
    #   should "should return the offset discounted_rate (offset based on rate) for the inventory" do
    #     assert_equal 50, decorated_package.discounted_rate
    #   end
    # end
    
  end
  
  
end
