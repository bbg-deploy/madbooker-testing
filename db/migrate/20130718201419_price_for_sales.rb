class PriceForSales < ActiveRecord::Migration
  def change
    add_column :sales, :price, :decimal, precision: 15, scale: 4
  end
end