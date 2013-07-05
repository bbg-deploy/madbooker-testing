class AddingInventoryThresholdAndCurrency < ActiveRecord::Migration
  def change
    add_column :hotels, :minimal_invenotry_notification_threshold, :integer, default: 0
    add_column :hotels, :currency_id, :integer, :default => 840
  end
end