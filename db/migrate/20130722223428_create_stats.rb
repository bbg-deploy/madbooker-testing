class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.integer     :hotel_id
      t.date        :start, :end
      t.string      :user_bug, :type, :url, :subdomain
      t.text        :data
      t.timestamps
    end
    
    add_index :stats, :hotel_id
    add_index :stats, :subdomain
    add_index :stats, :user_bug
    add_index :stats, :type
    add_index :stats, :url
    add_index :stats, [:start, :end]
    add_index :stats, :start
    add_index :stats, :end
    add_index :stats, :created_at
  end
end