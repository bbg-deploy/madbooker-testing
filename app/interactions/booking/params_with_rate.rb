class Booking::ParamsWithRate < Less::Interaction
    include Booking::Params

  
  expects :context
  
  def run
    booking_params_with_rate
  end

  private
  
  
  def available_rooms
    @available_rooms ||= Booking::RoomFinder.new(context: context).run.available_rooms
  end
  
  def rates
    if context.params[:booking][:bookable_type] == "Package"
      rate_from_package_from_available_rooms context.params[:booking][:bookable_id].to_i
    else
      rate_from_room_type_from_available_rooms context.params[:booking][:bookable_id].to_i
    end
  end
  
  def inventory_from_room_type_from_available_rooms room_type_id
    available_rooms.each do |inventory|
       return inventory if inventory.room_type_id == room_type_id
    end    
  end
  
  def rate_from_package_from_available_rooms package_id
      pack = context.hotel.packages.find(package_id)
      d_pack = pack.decorate.with_inventory inventory_from_room_type_from_available_rooms(pack.room_type_id)
      {rate: d_pack.rate, discounted_rate: d_pack.discounted_rate}
  end
  
  def rate_from_room_type_from_available_rooms room_type_id
    inventory = inventory_from_room_type_from_available_rooms room_type_id
    return {rate: nil, discounted_rate: nil} if inventory.blank?
    {rate: inventory.rate, discounted_rate: inventory.discounted_rate}
  end
  
  def booking_params_with_rate
    booking_params.merge rates
  end
  
  
end