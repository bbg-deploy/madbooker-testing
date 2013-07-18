class PricingForPackages < ActiveRecord::Migration
  def change
    rename_column :packages, :rate, :additional_price
    remove_column :packages, :discounted_rate
  end
end