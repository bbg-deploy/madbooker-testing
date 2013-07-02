class Booking::List < Less::Interaction
  
  expects :context
  
  def run
    list
  end
  
  private
  
  def list
    return @list if @list
    @list = []
    room_types.each do |room_type|
      @list << OpenStruct.new(
        name: room_type.name, 
        available: inventories[room_type.id].first.available_rooms, 
        booked: inventories[room_type.id].first.sales_count, 
        percent_booked: inventories[room_type.id].first.sales_count.to_d / inventories[room_type.id].first.available_rooms * 100, 
        rooms: grouped_rooms[room_type.id] || []
        )
    end
    @list
  end
  
  def room_types
    @room_types ||= context.hotel.room_types
  end
  
  def grouped_rooms
    @grouped_rooms ||= get_it context.hotel.bookings
  end
  
  def inventories
    @inventories ||= get_it context.hotel.inventories
  end
  
  def date
    Chronic.parse(context.params[:date]).to_date
  end
  
  def get_it arel
    arel.for_date(date).group_by {|x| x.room_type_id}
  end
  
end