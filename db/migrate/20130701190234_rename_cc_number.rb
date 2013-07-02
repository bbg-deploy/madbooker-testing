class RenameCcNumber < ActiveRecord::Migration
  def change
    rename_column :bookings, :cc_number, :encrypted_cc_number
    rename_column :bookings, :cc_cvv, :encrypted_cc_cvv
  end
end