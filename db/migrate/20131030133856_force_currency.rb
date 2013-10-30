class ForceCurrency < ActiveRecord::Migration
  def change
    change_column :hotels, :currency_id, :integer, default: 840
    
    Hotel.where(currency_id: nil).find_each do |h|
      h.update_attribute :currency_id, 840
    end
  end
end