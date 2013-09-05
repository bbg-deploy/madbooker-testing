class GaCodeTypeHotel < ActiveRecord::Migration
  def change
    add_column :hotels, :google_analytics_code_type, :string, :default => "Universal Analytics"
  end
end