class DeviceTypeToSales < ActiveRecord::Migration
  def change
    add_column :sales, :device_type, :string
    execute "update sales set device_type = 'mobile' where mobile = 1;"
    execute "update sales set device_type = 'desktop' where mobile != 1;"
    remove_column :sales, :mobile
    add_index :sales, :device_type
  end
end
