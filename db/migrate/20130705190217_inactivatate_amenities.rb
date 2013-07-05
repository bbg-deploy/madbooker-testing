class InactivatateAmenities < ActiveRecord::Migration
  def change
    add_column :amenities, :active, :boolean, default: true
  end
end