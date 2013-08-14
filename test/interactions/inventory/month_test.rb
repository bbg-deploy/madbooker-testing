require 'test_helper'

class Inventory::MonthTest < ActiveSupport::TestCase

  def month
    @month ||= Inventory::Month.new @date, nil
  end
  
  context "a month" do
    
    context "with no inventories" do
      setup do        
        @date = Date.new 2013,3
        month.stubs(:inventories).returns []
      end

      should "have no inventories" do
        assert_equal [], month.inventories
      end
      
      should "have no inventories on any date" do
        (@date-2..@date.advance(months: 1)).each do |d|
          assert_equal [], month.inventory_on(d)
        end
      end
      
      should "have previous month set to feb" do
        assert_equal Date.new(2013, 02,01), month.previous_month
      end
      
      should "have next month set to apr" do
        assert_equal Date.new(2013, 04,01), month.next_month
      end
    end
    
    context "with some inventory" do
      setup do        
        @date = Date.new 2013,3
        @a = moc "inventory", date: @date+3
        @b = moc "inventory", date: @date+4
        @c = moc "inventory", date: @date+5
        month.stubs(:inventories).returns [ @a,@b,@c]
      end

      
      should "have some inventories" do
        (@date-2..@date.advance(months: 1)).each do |d|
          if d == @a.date
            o = [@a]
          elsif d == @b.date
            o = [@b]
          elsif d == @c.date
            o = [@c]
          else
            o = []
          end
          assert_equal o, month.inventory_on(d)
        end
      end
    end
    
  end
  
  
  
end