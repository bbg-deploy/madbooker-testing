class Inventory::Form < Less::Interaction

  expects :context
  
  
  def run
    build
  end
  
  def hotel
    @fake_hotel ||= Inventory::FakeHotel.new id: context.hotel.id
  end
  
  def range
    @range ||= Date.parse(context.params[:start])..Date.parse(context.params[:end])
  end
  
  private
  
  def build
    i = []
    context.hotel.room_types.each do |room_type|
      if usables[room_type.id]
        i << convert_prototype_to_inventory( room_type, usables[room_type.id])
      else
        i << convert_room_type_to_inventory(room_type)
      end
    end
    hotel.inventories = i
    self
  end
  
  
  def inventories
    @inventories ||= context.hotel.inventories.for_range range
  end
  
  def usables
    return @usable if @usable
    return {} if inventories.blank?
    usable = {}
    survey.each do |room_type_id, prototype|
      x = {}
      [:available_rooms, :rate, :discounted_rate].each do |attribute|
        if prototype[attribute].uniq.size == 1
          prototype["#{attribute}_usable".to_sym] = true
          x[attribute] = prototype[attribute].uniq.first
        end
      end
      usable[room_type_id] = x unless x.blank?
    end
    @usable = usable
  end
  
  def survey
    return @survey if @survey
    prototypes = {}
    inventories.each do |i|
      prototype = setup_prototype i, prototypes
      prototype[:available_rooms] << i.available_rooms
      prototype[:rate]            << i.rate
      prototype[:discounted_rate] << i.discounted_rate
    end
    @survey = prototypes
  end
  
  def setup_prototype inventory, prototypes
    if prototypes[inventory.room_type_id].blank?
      prototypes[inventory.room_type_id] = {available_rooms: [], rate: [], discounted_rate: [], available_rooms_usable: false, rate_usable: false, discounted_rate_usable: false}
    else
      prototypes[inventory.room_type_id]      
    end
  end
  
  def convert_room_type_to_inventory room_type
    Inventory.new id: room_type.id, room_type_id:    room_type.id, available_rooms: room_type.number_of_rooms, rate:   room_type.default_rate, discounted_rate: room_type.discounted_rate
  end
  
  def convert_prototype_to_inventory room_type, useable
    i = convert_room_type_to_inventory room_type
    useable.each do |attr, val|
      i.send "#{attr}=", val
    end
    i
  end
  
  
end