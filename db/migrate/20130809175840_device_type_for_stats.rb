class DeviceTypeForStats < ActiveRecord::Migration
  def change
    add_column :stats, :device_type, :string
    execute "update stats set device_type = 'mobile' where mobile = 1;"
    execute "update stats set device_type = 'desktop' where mobile != 1;"
    remove_column :stats, :mobile
    add_index :stats, :device_type
  end
end