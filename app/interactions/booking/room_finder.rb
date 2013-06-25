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
    # -1 cuz the inventory day reflect the night of the stay, 
    # so a range of two days is really just an inventory search for the first date.
    # A range of one day is invalid because people book for a night and two days.
    @range ||= Chronic.parse( context.params[:booking][:arrive]).to_date..(Chronic.parse( context.params[:booking][:depart]).to_date-1)
  end
  
  def inventories
    @inventories ||= context.hotel.inventories.for_range(range).with_availablity
  end
  
  def available_rooms
    return @available_rooms if @available_rooms
    rooms = []
    inventories.group_by {|r| r.room_type_id }.each do |room_type_id, inv|
      catch :missing_date do
        range.each do |date|
          throw :missing_date unless inv.any? {|i| i.date == date}
        end
        rooms << first_or_average_inventory(inv)
      end
    end
    @available_rooms = rooms
  end
  
  def first_or_average_inventory inventories
    if inventories.map(&:rate).average == inventories.first.rate && inventories.map(&:discounted_rate).average == inventories.first.discounted_rate
      #match so just return the first one
      inventories.first
    else
      Inventory.new( rate: inventories.map(&:rate).average,
        discounted_rate: inventories.map(&:discounted_rate).average,
        room_type_id: inventories.first.room_type_id,
        date: inventories.first.date,
        hotel_id: inventories.first.hotel_id
      )
    end
  end
    
end