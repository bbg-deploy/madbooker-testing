class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.integer     :inventory_id, :booking_id, :hotel_id
      t.decimal     :rate, :discounted_rate,  :precision => 15, :scale => 4, :default => 0.0
      t.date        :date
      t.timestamps
    end
    
    remove_column :bookings, :inventory_id, :integer
    remove_column :inventories, :bookings_count, :integer
    add_column :inventories, :sales_count, :integer, :default => 0
  end
end