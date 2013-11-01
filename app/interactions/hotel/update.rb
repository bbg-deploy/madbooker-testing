class Hotel::Update < Less::Interaction
  include Hotel::Params
  
  expects :context
  
  def run    
    update
  end
  
  private
  def hotel
    @hotel ||= context.hotel
  end
  
  def update
    res = Less::Response.new 200, hotel
    res.status = 500 unless save
    res.object = hotel
    res
  end
  
  def save
    begin
      Hotel.transaction do
        ensure_deleting_room_type_is_safe_to_delete
        hotel.update_attributes! hotel_params
        if hotel.room_types.reload.count == 0
          hotel.errors.add :base, "You must have at least one room type."
          raise ActiveRecord::RecordInvalid.new hotel
        end
        inventory_sync.run
      end
    rescue ActiveRecord::RecordInvalid=>e
      Exceptions.record e, context
      return false
    end
    true
  end
  
  def inventory_sync
    @inventory_sync ||= Inventory::SyncWithRoomTypes.new( inv_context, range: range, raises: true)
  end
  
  def inv_context
    @inv_context ||= Context.new user: context.user, hotel: hotel, params: inventory_params
  end
  
  def range
    return @range if @range
    end_date = hotel.inventories.reorder("date desc").first.date
    @range ||= Date.current..end_date
  end
  
  def inventory_params
    return @inventory_params if @inventory_params
    inv = []
    hotel.room_types.each do |rt|
      inv << {
        room_type_id: rt.id, 
        available_rooms: rt.number_of_rooms, 
        rate: rt.default_rate, 
        discounted_rate: rt.discounted_rate
      }
    end
    @inventory_params = inv
  end
  
  def ensure_deleting_room_type_is_safe_to_delete
    context.params[:hotel][:room_types_attributes].each do |index, room_attr|
      next unless room_attr[:_destroy].to_bool
      room_type = hotel.room_types.find room_attr[:id]
      raise_cant_delete_room_type if room_type.bookings.count > 0
      room_type.packages.each do |package|
        raise_cant_delete_room_type if package.bookings.count > 0
      end
    end
  end
  
  def raise_cant_delete_room_type
    hotel.errors.add :base, "You can not delete a room type that has bookings."
    raise ActiveRecord::RecordInvalid.new hotel
  end
  
end
