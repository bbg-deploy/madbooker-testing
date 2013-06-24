class MoreFieldsForBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :first_name, :string
    add_column :bookings, :last_name, :string
    add_column :bookings, :made_by_first_name, :string
    add_column :bookings, :made_by_last_name, :string
    add_column :bookings, :email, :string
    add_column :bookings, :email_confirmation, :string
    add_column :bookings, :sms_confirmation, :string
    add_column :bookings, :cc_number, :string
    add_column :bookings, :cc_month, :integer
    add_column :bookings, :cc_year, :integer
    add_column :bookings, :cc_cvv, :string
    add_column :bookings, :cc_zipcode, :string
  end
end