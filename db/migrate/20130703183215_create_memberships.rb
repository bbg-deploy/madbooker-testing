class CreateMemberships < ActiveRecord::Migration
  def up
    create_table :memberships do |t|
      t.integer     :hotel_id, :user_id
      t.string      :email
      t.timestamps
    end

    execute "insert into memberships (hotel_id, user_id) select id, user_id from hotels"
    
    rename_column :hotels, :user_id, :owner_id 
  end
  
  def down
    rename_column :hotels, :owner_id, :user_id
    drop_table :memberships    
  end
end
