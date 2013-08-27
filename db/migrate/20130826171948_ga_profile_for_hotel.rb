class GaProfileForHotel < ActiveRecord::Migration
  def change
    add_column :hotels, :ga_account_id, :string
    add_column :hotels, :ga_profile_id, :string
  end
end