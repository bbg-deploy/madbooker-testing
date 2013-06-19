class DefaultValForBookingsCount < ActiveRecord::Migration
  def up
    change_column_default :inventories, :bookings_count, 0
    execute "update inventories set bookings_count = 0"
  end
  
  def down
    
  end
end