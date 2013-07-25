class RenameMisspelledInvenotryColumn < ActiveRecord::Migration
  def change
    rename_column :hotels, :minimal_invenotry_notification_threshold, :minimal_inventory_notification_threshold
  end
end