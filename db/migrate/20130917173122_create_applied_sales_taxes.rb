class CreateAppliedSalesTaxes < ActiveRecord::Migration
  def change
    create_table :applied_sales_taxes do |t|
      t.integer     :booking_id, :sales_tax_id, :quantity
      t.string      :name, :calculated_by, :calculated_how
      t.decimal     :amount, :total, precision: 15, scale: 2
      t.timestamps
    end
  end
end
