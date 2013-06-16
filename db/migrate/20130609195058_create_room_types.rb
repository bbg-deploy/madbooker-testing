class CreateRoomTypes < ActiveRecord::Migration
  def change
    create_table :room_types do |t|
      t.integer     :hotel_id, :number_of_rooms
      t.string      :name
      t.decimal     :default_rate, :discounted_rate,  :precision => 15, :scale => 4, :default => 0.0
      t.text        :description
      t.timestamps
    end
  end
end
