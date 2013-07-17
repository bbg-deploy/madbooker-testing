class Inventory::SyncWithRoomTypes < Less::Interaction

  expects :raises, :range

  # for this interaction, the params is just an array of inventory attributes
  # to be used to prototyping creates.
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
        create_new_inventories!
        update_existing_inventories!
      end
    rescue ActiveRecord::RecordInvalid
      raise #if raises
      context.hotel.inventories = @inventory_prototypes
      return Less::Response.new 500, context.hotel
    end
    Less::Response.new 200, context.hotel    
  end
  
  
  def inventory_prototypes
    return @inventory_prototypes if @inventory_prototypes
    inv = []
    context.params.each do |values|
      values.symbolize_keys! if values.respond_to? :symbolize_keys!
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
  
  def create_new_inventories!
    missing_dates.each do |date|
      inventory_prototypes.each do |inventory_proto|
        hotel.inventories.create! inventory_proto.attributes.merge(date: date)
      end
    end
  end
  
  def update_existing_inventories!
    inventory_prototypes.each do |inventory_proto|
      att = inventory_proto.attributes
      %w(sales_count created_at updated_at id room_type_id hotel_id date).each {|a| att.delete a}
      hotel.inventories.where(date: range).where(room_type_id: inventory_proto.room_type_id).update_all(att)
    end
  end
  
  def missing_dates
    return @missing_dates if @missing_dates
    has_dates = hotel.inventories.select("date").where(date: range).order("date asc").pluck("date")
    @missing_dates = range.to_a - has_dates
  end
  
  
  def valid?
    valids = inventory_prototypes.map &:valid?
    return true if valids.uniq.size == 1 && valids.first
    false
  end
  
  
end