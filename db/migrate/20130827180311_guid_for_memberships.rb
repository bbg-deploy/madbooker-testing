class GuidForMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :guid, :string
  end
end