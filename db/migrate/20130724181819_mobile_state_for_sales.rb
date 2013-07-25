class MobileStateForSales < ActiveRecord::Migration
  def change
    add_column :sales, :mobile, :boolean, default: false
    add_column :sales, :state, :string
    
    add_index :sales, :inventory_id
    add_index :sales, :booking_id
    add_index :sales, :hotel_id
    add_index :sales, :state
    
    Sale.reset_column_information
    
    execute "UPDATE sales, bookings SET sales.state = bookings.state WHERE sales.booking_id = bookings.id"
  end
end