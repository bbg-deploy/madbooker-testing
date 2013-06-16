class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.integer     :hotel_id, :room_type_id, :available_rooms, :bookings_count
      t.decimal     :override_rate, :discounted_rate,  :precision => 15, :scale => 4, :default => 0.0
      t.date        :date
      t.timestamps
    end
  end
end
