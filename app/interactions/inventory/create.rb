class Inventory::Create < Less::Interaction

  
  
  def run
    sync = Inventory::SyncWithRoomTypes.new inv_context, range: range, raises: false
    res = sync.run
  end
  
  # we need a fake hotel because there may be a million inventories associated with the real hotel, 
  # but we really just want to return the prototypes of inventories to the form.
  def hotel
    @fake_hotel ||= Inventory::FakeHotel.new context.hotel.id
  end
    
  private
  
  
  def inv_context
    Context.new hotel: hotel, user: context.user, params: inventory_params
  end
  
  def range
    @range ||= Date.parse(context.params[:hotel][:start])..Date.parse(context.params[:hotel][:end])
  end
  
  def inventory_params
    @inventory_params ||= context.params[:hotel][:inventories_attributes].map {|k,v| v}
  end
  
  
end