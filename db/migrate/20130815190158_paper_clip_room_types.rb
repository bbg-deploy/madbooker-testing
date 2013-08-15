class PaperClipRoomTypes < ActiveRecord::Migration
  def self.up
    add_attachment :room_types, :image
  end

  def self.down
    remove_attachment :room_types, :image
  end
end
