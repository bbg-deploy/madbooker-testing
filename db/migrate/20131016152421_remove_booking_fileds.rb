class RemoveBookingFileds < ActiveRecord::Migration
  def change
    remove_column :bookings, :made_by_first_name, :string
    remove_column :bookings, :made_by_last_name, :string
    remove_column :bookings, :email_confirmation, :string
  end
end