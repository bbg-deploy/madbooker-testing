class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string      :code, :html_symbol, :name
      t.timestamps
    end
  end
end
