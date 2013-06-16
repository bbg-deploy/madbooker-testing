class AllowNullsForDiscountedRates < ActiveRecord::Migration
  def up
    change_column :inventories, :discounted_rate, :decimal, precision: 15, scale: 4, allow_null: true, default: nil
    change_column :room_types, :discounted_rate, :decimal, precision: 15, scale: 4, allow_null: true, default: nil
    rename_column :inventories, :override_rate, :rate
  end
  
  def down
    rename_column :inventories, :rate, :override_rate
    change_column :room_types, :discounted_rate, :decimal, precision: 15, scale: 4, allow_null: true, default: nil
    change_column :inventories, :discounted_rate, :decimal, precision: 15, scale: 4, allow_null: true, default: nil
  end
end