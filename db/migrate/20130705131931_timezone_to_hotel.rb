class TimezoneToHotel < ActiveRecord::Migration
  def change
    add_column :hotels, :time_zone, :string, :default => "Eastern Time (US & Canada)"
  end
end