class Inventory::SyncWithRoomTypes < Less::Interaction

  expects :inventory_params, :raises, :range

  def run
    if !raises && !valid?
      context.hotel.inventories = @inventory_prototypes
      return Less::Response.new 500, context.hotel
    end

    light_this_shit_up
  end
  
  private
  
  def light_this_shit_up
    begin
      ActiveRecord::Base.transaction do
        clear_exisitng_inventories!
        save_new_inventories!
      end
    rescue ActiveRecord::RecordInvalid
      raise if raises
      context.hotel.inventories = @inventory_prototypes
      return Less::Response.new 500, context.hotel
    end
    Less::Response.new 200, context.hotel    
  end
  
  
  def inventory_prototypes
    return @inventory_prototypes if @inventory_prototypes
    inv = []
    inventory_params.each do |values|
      inv << Inventory.new(
        room_type_id: values[:room_type_id], 
        available_rooms: values[:available_rooms], 
        rate: values[:rate], 
        discounted_rate: values[:discounted_rate],
        hotel_id: context.hotel.id,
        date: Date.current #replaced in save_new_inventories, but need some value for validation
      )
    end
    @inventory_prototypes = inv
  end
  
  #grab by Hotel because context.hotel may be a fake hotel. See explaination in Inventory::Create.hotel
  def hotel
    return @hotel if @hotel
    @hotel = context.hotel if context.hotel.is_a? Hotel
    @hotel ||= Hotel.find(context.hotel.id)
  end
  
  def clear_exisitng_inventories!
    hotel.inventories.where( date: range).delete_all
  end
  
  def save_new_inventories!
    inv = []
    range.each do |date|
      inventory_prototypes.each do |inventory_proto|
        hotel.inventories.create! inventory_proto.attributes.merge(date: date)
      end
    end
  end
  
  
  def valid?
    valids = inventory_prototypes.map &:valid?
    return true if valids.uniq.size == 1 && valids.first
    false
  end
  
  
end