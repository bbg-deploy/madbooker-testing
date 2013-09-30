class TotalForBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :total, :decimal, precision: 15, scale: 2
    add_column :sales, :total, :decimal, precision: 15, scale: 2
  end
end