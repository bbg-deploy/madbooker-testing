class CreateAmenities < ActiveRecord::Migration
  def change
    create_table :amenities do |t|
      t.integer     :hotel_id
      t.string      :name
      t.text        :description
      t.decimal     :price, precision: 15, scale: 4
      t.timestamps
    end
  end
end
