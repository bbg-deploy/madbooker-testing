class HotelPaid < ActiveRecord::Migration
  def change
    add_column :bookings, :paid, :datetime, allow_null: true
  end
end