class AddressForHotel < ActiveRecord::Migration
  def change
    rename_column :hotels, :address, :street1
    change_column :hotels, :street1, :string
    add_column :hotels, :street2, :string
    add_column :hotels, :street3, :string
    add_column :hotels, :city, :string
    add_column :hotels, :state, :string
    add_column :hotels, :country, :string
    add_column :hotels, :postal_code, :string
    add_column :hotels, :email, :string
  end
end