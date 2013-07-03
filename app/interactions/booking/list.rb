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
        available: inventory(room_type.id, :available_rooms), 
        booked: inventory(room_type.id, :sales_count), 
        percent_booked: inventory(room_type.id, :percent_booked),
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
  
  def inventory room_type_id, method
    return nil unless inventories[room_type_id].try :first
    if method == :percent_booked
      inventories[room_type_id].first.sales_count.to_d / inventories[room_type_id].first.available_rooms * 100
    else
      inventories[room_type_id].first.send method
    end
  end
  
  def date
    Chronic.parse(context.params[:date]).to_date
  end
  
  def get_it arel
    arel.for_date(date).group_by {|x| x.room_type_id}
  end
  
end