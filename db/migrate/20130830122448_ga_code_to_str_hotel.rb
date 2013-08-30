class GaCodeToStrHotel < ActiveRecord::Migration
  def change
    change_column :hotels, :google_analytics_code, :string
  end
end