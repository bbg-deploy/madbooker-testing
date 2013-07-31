class Booking::RoomFinder < Less::Interaction
  
  expects :context
  
  def run
    self
  end
  
  # returns all the available rooms for each room type
  def all_rooms
    available_rooms unless @available_rooms
    @all_rooms
  end
  
  # available_rooms will return a prototype of an inventory with the rate and discounted rate properly set.
  # It takes into account, differences in prices betweed days, differences in discount_rates, and availablity
  def available_rooms
    return @available_rooms if @available_rooms
    @available_rooms = []
    @all_rooms = {}
    inventories.group_by {|r| r.room_type_id }.each do |room_type_id, inv|
      catch :missing_date do
        range.each do |date|
          throw :missing_date unless inv.any? {|i| i.date == date}
        end
        @available_rooms << first_or_average_inventory(inv)
        @all_rooms[room_type_id] = inv
      end
    end
    @available_rooms
  end
  
  private
  
  def range
    # -1 cuz the inventory day reflect the night of the stay, 
    # so a range of two days is really just an inventory search for the first date.
    # A range of one day is invalid because people book for a night and two days.
    @range ||= Chronic.parse( context.params[:booking][:arrive]).to_date..(Chronic.parse( context.params[:booking][:depart]).to_date-1)
  end
  
  def inventories
    @inventories ||= context.hotel.inventories.range(range).with_availablity
  end
  
  def first_or_average_inventory inventories
    if all_the_same?(inventories.map(&:rate)) && all_the_same?(inventories.map(&:discounted_rate))
      #match so just return the first one
      inventories.first
    else
      Inventory.new( rate: inventories.map(&:rate).average,
        discounted_rate: discounted_average( inventories),
        room_type_id: inventories.first.room_type_id,
        date: inventories.first.date,
        hotel_id: inventories.first.hotel_id
      )
    end
  end
  
  def all_the_same? arr
    tester = arr.first
    arr.all? {|i| i == tester}
  end
  
  def discounted_average inventories
    arr = []
    inventories.each do |inventory|
      if inventory.discounted_rate
        arr << inventory.discounted_rate
      else
        arr << inventory.rate
      end
    end
    arr.average
  end
    
end