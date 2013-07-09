class CreateBundles < ActiveRecord::Migration
  def change
    create_table :bundles do |t|
      t.integer     :package_id, :add_on_id
      t.timestamps
    end
  end
end
