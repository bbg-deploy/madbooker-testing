class DefaultRateForRoomType < ActiveRecord::Migration
  def change
    change_column :add_ons, :price, :decimal, :precision => 15, :scale => 4, :default => nil, :allow_null => false
    change_column :sales, :rate, :decimal, :precision => 15, :scale => 4, :default => nil, :allow_null => false
    change_column :packages, :rate, :decimal, :precision => 15, :scale => 4, :default => nil, :allow_null => false
    change_column :inventories, :rate, :decimal, :precision => 15, :scale => 4, :default => nil, :allow_null => false
    change_column :room_types, :default_rate, :decimal, :precision => 15, :scale => 4, :default => nil, :allow_null => false
  end
end