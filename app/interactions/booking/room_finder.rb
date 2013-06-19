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
    rooms = []
    inventories.group_by {|r| r.room_type_id }.each do |room_type_id, inv|
      has = []
      range.each do |date|
        has << !inv.select{|i| i.date == date}.blank?
      end
      rooms <<(inv.first) if has.uniq.size == 1 && has.uniq.first 
    end
    @available_rooms = rooms
  end
    
end