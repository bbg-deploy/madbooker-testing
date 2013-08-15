class RoomTypesController < ApplicationController

  def delete_image
    render nothing: true and return unless can? :update, current_hotel
    @room_type = current_hotel.room_types.find(params[:id])
    @room_type.update_attribute :image, nil
  end    
end
