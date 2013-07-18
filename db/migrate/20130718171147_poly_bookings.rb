class PolyBookings < ActiveRecord::Migration
  def change
    rename_column :bookings, :room_type_id, :bookable_id
    add_column :bookings, :bookable_type, :string
    
    execute "update bookings set bookable_type = 'RoomType'"
  end
end