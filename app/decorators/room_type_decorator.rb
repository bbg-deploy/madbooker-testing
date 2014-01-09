class RoomTypeDecorator < ApplicationDecorator
  delegate_all
  
  def description
    sub_breaks model.description
  end
  
end