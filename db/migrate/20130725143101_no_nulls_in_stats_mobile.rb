class NoNullsInStatsMobile < ActiveRecord::Migration
  def change
    change_column :stats, :mobile, :boolean, allow_null: false, default: false
  end
end