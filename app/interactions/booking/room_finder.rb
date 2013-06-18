class Booking::RoomFinder < Less::Interaction
  
  expects :context
  
  def run
    res = Less::Response.new 400, []
    res.object = available_rooms
    res.status = 200 unless available_rooms.blank?
    res
  end
  
  private
  
  def range
    @range ||= Chronic.parse( context.params[:booking][:arrive]).to_date..Chronic.parse( context.params[:booking][:depart]).to_date
  end
  
  def available_rooms
    return @available_rooms if @available_rooms
    rooms = context.hotel.inventories.for_range(range).with_availablity
    @available_rooms = 
  end
end