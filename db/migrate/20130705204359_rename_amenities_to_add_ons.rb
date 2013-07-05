class RenameAmenitiesToAddOns < ActiveRecord::Migration
  def change
    rename_table :amenities, :add_ons
  end
end