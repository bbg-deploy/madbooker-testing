class GauthHotel < ActiveRecord::Migration
  def change
    add_column :hotels, :gauth_access_token, :string
    add_column :hotels, :gauth_refresh_token, :string
    add_column :hotels, :gauth_expires_in, :integer
    add_column :hotels, :gauth_issued_at, :datetime 
  end
end