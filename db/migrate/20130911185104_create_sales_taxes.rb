class CreateSalesTaxes < ActiveRecord::Migration
  def change
    create_table :sales_taxes do |t|
      t.string        :name, :calculated_by, :calculated_how
      t.decimal       :amount, precision: 15, scale: 2
      t.integer       :hotel_id
      t.timestamps
    end
  end
end
