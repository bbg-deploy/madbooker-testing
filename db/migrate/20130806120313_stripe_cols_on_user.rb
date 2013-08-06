class StripeColsOnUser < ActiveRecord::Migration
  def change
    add_column :users, :stripe_customer_id, :string
    add_column :users, :payment_status, :string
  end
end