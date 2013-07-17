class Hotel::Create < Less::Interaction
  include Hotel::Params
  
  expects :context
  
  def run    
    create
  end
  
  private
  def hotel
    @hotel ||= Hotel.new hotel_params.merge(owner_id: context.user.id)
  end
  
  def create
    save
    hotel
  end
  
  def save
    begin
      Hotel.transaction do
        hotel.save!
        if hotel.room_types.count == 0
          hotel.errors.add :base, "You must have at least one room type."
          raise ActiveRecord::RecordInvalid.new hotel
        end
        hotel.memberships.create! user_id: context.user.id, email: context.user.email
        inventory_create.run
      end
    rescue ActiveRecord::RecordInvalid=>e
      Exceptions.record e
      false
    end
    true
  end
  
  def inventory_create
    @inventory_create ||= Inventory::SyncWithRoomTypes.new( inv_context, range: range, raises: true)
  end
  
  def inv_context
    @inv_context ||= Context.new user: context.user, hotel: hotel, params: inventory_params
  end
  
  def range
    @range ||= Date.current..(Date.current.advance( years: 2) - 1)
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
  
end
