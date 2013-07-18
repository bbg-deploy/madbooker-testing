class InventoryDecorator < ApplicationDecorator
  delegate_all
  
  decorates_association :room_type
  
  delegate :name, :description, to: :room_type


end
