class Inventory::Create < Less::Interaction

  expects :context
  
  
  def run
    init_output
    build_new_inventories
    @response.status = 400 and return @response unless valid?
    ActiveRecord::Base.transaction do
      clear_exisitng_inventories
      save_new_inventories
    end
    @response
  end
  
  def hotel
    @fake_hotel ||= Inventory::FakeHotel.new id: context.hotel.id
  end
  
  def range
    @range ||= Date.parse(context.params[:hotel][:start])..Date.parse(context.params[:hotel][:end])
  end
  
  private
  
  def init_output
    @response = Less::Response.new 200, self
  end
  
  def build_new_inventories
    return @inventories if @inventories
    inv = []
    context.params[:hotel][:inventories_attributes].each do |index, values|
      inv << Inventory.new(
        room_type_id: values[:room_type_id], 
        available_rooms: values[:available_rooms], 
        rate: values[:rate], 
        discounted_rate: values[:discounted_rate],
        hotel_id: context.hotel.id,
        date: Date.current #replaced in save_new_inventories, but need some value for validation
      )
    end
    @inventories = inv
  end
  
  def valid?
    valids = @inventories.map &:valid?
    return true if valids.uniq.size == 1 && valids.first
    hotel.inventories = @inventories
    false
  end
  
  def clear_exisitng_inventories
    context.hotel.inventories.where( date: range).delete_all
  end
  
  def save_new_inventories
    range.each do |date|
      @inventories.each do |inventory_proto|
        context.hotel.inventories.create! inventory_proto.attributes.merge(date: date)
      end
    end
  end
  
  
end