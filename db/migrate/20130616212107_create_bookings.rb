class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.integer     :hotel_id, :customer_id, :room_type_id, :inventory_id
      t.date        :arrive, :depart
      t.decimal     :rate, :discounted_rate, precision: 15, scale: 4
      t.timestamps
    end
  end
end
