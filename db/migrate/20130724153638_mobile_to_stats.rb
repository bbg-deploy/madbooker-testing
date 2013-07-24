class MobileToStats < ActiveRecord::Migration
  def change
    add_column :stats, :mobile, :boolean, default: false
  end
end