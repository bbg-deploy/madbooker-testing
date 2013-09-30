require 'test_helper'

class SalesTaxDecoratorTest < Draper::TestCase
  
  
  context "per night percentage" do
    setup do
      @s = Gen.sales_tax( calculated_by: SalesTax::PER_NIGHT, calculated_how: SalesTax::PERCENTAGE, amount: 32.23).decorate
    end

    should "price is correct for 1 night" do
      assert_equal 3.22, @s.price(10, 1)
    end
    should "price is correct for 5 nights" do
      assert_equal 16.1, @s.price(10, 5)
    end
    should "quantity is correct for 1 night" do
      assert_equal 1, @s.quantity(1)
    end
    should "quantity is correct for 5 nights" do
      assert_equal 5, @s.quantity(5)
    end
  end
  
  
  context "per night fixed" do
    setup do
      @s = Gen.sales_tax( calculated_by: SalesTax::PER_NIGHT, calculated_how: SalesTax::FIXED_AMOUNT, amount: 32.23).decorate
    end

    should "price is correct for 1 night" do
      assert_equal 32.23, @s.price(10, 1)
    end
    should "price is correct for 5 nights" do
      assert_equal 161.15, @s.price(10, 5)
    end
    should "quantity is correct for 1 night" do
      assert_equal 1, @s.quantity(1)
    end
    should "quantity is correct for 5 nights" do
      assert_equal 5, @s.quantity(5)
    end
  end
  
  
  context "per stay percentage" do
    setup do
      @s = Gen.sales_tax( calculated_by: SalesTax::PER_STAY, calculated_how: SalesTax::PERCENTAGE, amount: 32.23).decorate
    end

    should "price is correct for 1 night" do
      assert_equal 3.22, @s.price(10, 1)
    end
    should "price is correct for 5 nights" do
      assert_equal 3.22, @s.price(10, 5)
    end
    should "quantity is correct for 1 night" do
      assert_equal 1, @s.quantity(1)
    end
    should "quantity is correct for 5 nights" do
      assert_equal 1, @s.quantity(5)
    end
  end
  
  
  context "per stay fixed" do
    setup do
      @s = Gen.sales_tax( calculated_by: SalesTax::PER_STAY, calculated_how: SalesTax::FIXED_AMOUNT, amount: 32.23).decorate
    end

    should "price is correct for 1 night" do
      assert_equal 32.23, @s.price(10, 1)
    end
    should "price is correct for 5 nights" do
      assert_equal 32.23, @s.price(10, 5)
    end
    should "quantity is correct for 1 night" do
      assert_equal 1, @s.quantity(1)
    end
    should "quantity is correct for 5 nights" do
      assert_equal 1, @s.quantity(5)
    end
  end
  
  
end
