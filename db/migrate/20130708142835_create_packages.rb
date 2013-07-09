class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.integer     :hotel_id, :room_type_id
      t.decimal     :rate,  :precision => 15, :scale => 4, :default => 0.0
      t.decimal     :discounted_rate,  :precision => 15, :scale => 4, :default => nil, :allow_null => true
      t.timestamps
    end
    
    change_column :sales, :discounted_rate, :decimal, :precision => 15, :scale => 4, :default => nil, :allow_null => true
  end
end