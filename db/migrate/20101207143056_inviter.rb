class Inviter < ActiveRecord::Migration
  def self.up
    add_column :project_memberships, :invited_by_id, :integer
  end

  def self.down
    remove_column :project_memberships, :invited_by_id
  end
end
