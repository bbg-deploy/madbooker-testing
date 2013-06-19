class Booking::RoomFinder < Less::Interaction
  
  expects :context
  
  def run
    res = Less::Response.new 400, available_rooms
    if res.object.blank?
      res.status = 400
    else
      res.status = 200
    end
    res
  end
  
  private
  
  def range
    @range ||= Chronic.parse( context.params[:booking][:arrive]).to_date..Chronic.parse( context.params[:booking][:depart]).to_date
  end
  
  def inventories
    @inventories ||= context.hotel.inventories.for_range(range).with_availablity
  end
  
  def available_rooms
    return @available_rooms if @available_rooms
    
    if available_ids.blank?
      @available_rooms = [] 
    else
      @available_rooms = room_types available_ids
    end
  end
  
  def room_types ids
    context.hotel.room_types.all ids  
  end
  
  def available_ids
    return @available_ids if @available_ids
    room_type_ids = []
    rooms = inventories
    grouped = rooms.group_by {|r| r.room_type_id }
    grouped.each do |room_type_id, inventories|
      has = []
      range.each do |date|
        has << !inventories.select{|i| i.date == date}.blank?
      end
      room_type_ids <<(room_type_id) if has.uniq.size == 1 && has.uniq.first 
    end
    @available_ids = room_type_ids
  end
  
end