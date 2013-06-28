class AddGuidToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :guid, :string
  end
end