class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.integer  "user_id"
      t.string   "first_name"
      t.string   "last_name"
      t.string   "icon"
      t.string   "email"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
