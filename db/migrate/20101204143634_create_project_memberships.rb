class CreateProjectMemberships < ActiveRecord::Migration
  def self.up
    create_table :project_memberships do |t|
      t.integer     :person_id, :project_id
      t.boolean     :owner, :default => false, :allow_null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :project_memberships
  end
end
