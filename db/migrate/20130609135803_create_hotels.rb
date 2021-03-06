class CreateHotels < ActiveRecord::Migration
  def change
    create_table :hotels do |t|
      t.integer     :user_id
      t.string      :name, :url, :phone, :fax, :room_rates_display, :time_zone, :subdomain
      t.text        :address, :google_analytics_code, :fine_print
      t.attachment  :logo
      t.timestamps
    end
  end
end
