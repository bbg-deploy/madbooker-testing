class InventoryDecorator < ApplicationDecorator
  delegate_all
  
  decorates_association :room_type
  
  delegate :name, :description, :image, to: :room_type
  

end
