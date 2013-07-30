class RenameStatType < ActiveRecord::Migration
  def change
    rename_column :stats, :type, :kind
  end
end