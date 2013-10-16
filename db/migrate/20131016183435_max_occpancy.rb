class MaxOccpancy < ActiveRecord::Migration
  def change
    add_column :room_types, :max_occupancy, :integer
    
    execute "update room_types set max_occupancy = 5"
    
  end
end