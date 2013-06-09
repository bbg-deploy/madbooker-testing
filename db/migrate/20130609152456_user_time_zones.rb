class UserTimeZones < ActiveRecord::Migration
  def change
    remove_column :hotels, :time_zone, :string
    add_column :users, :time_zone, :string
  end
end