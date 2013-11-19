class Reports::RevenueByRoomType < Less::Interaction
  
  
  def run
    self
  end
  
  def revenue
    @revenue ||= fill_data(get_revenue_data).to_json
  end
  
  def booking
    @booking ||= fill_data(get_booking_data).to_json
  end
  
  private 
  def get_revenue_data
    context.hotel.sales.range(Date.year).joins(:booking).group("bookings.bookable_id", "bookings.bookable_type", "month(date)").paid.sum( :total).log
  end
  
  def get_booking_data
    context.hotel.sales.range(Date.year).joins(:booking).group("bookings.bookable_id","bookings.bookable_type", "month(date)").paid.count
  end
  
  def fill_data input
    out = init_rows
    ensure_empty_room_types_are_respresented out
    input.each do |datum|
      bookable_id = datum[0][0]
      bookable_type = datum[0][1]
      month = date_for_month datum[0][2]
      amount = datum[1].round(0)
      row = out.select{|x| x.date == month}.first
      next unless row
      fill_room_data row.rooms, bookable_id: bookable_id, bookable_type: bookable_type, amount: amount
    end
    normalize_data out
  end
  
  def ensure_empty_room_types_are_respresented arr
    room_types = context.hotel.room_types
    arr.each do |month|
    room_types.each do |room_type|
        month.rooms << inited_room( room_type.id, 0.0, room_type.name)
      end
    end
  end
  
  def normalize_data arr
    out = []
    names = []
    arr.each do |month|
      total = 0.0
      o = OpenStruct.new
      o.date = month.date
      month.rooms.each do |room|
        o[room.name] = room.amount
        total += room.amount
        names << room.name
      end
      o.total = total
      out << o
    end
    ensure_each_row_has_all_columns out, names.uniq
  end
  
  def ensure_each_row_has_all_columns arr, names
    arr.each do |row|
      names.each do |name|
        row[name] = 0.0 if row[name].nil?
      end
    end
  end
  
  def fill_room_data arr, bookable_id: bookable_id, bookable_type: bookable_type, amount: amount
    room_type = get_room_type bookable_id, bookable_type
    room = arr.select{|x| x.room_type_id == room_type.id}.first
    if room
      room.amount += amount
    else
      #this shouldn't be neccasary anymore cuz the initing is done in ensure_empty_room_types_are_respresented
      #but i left it in because I'm scared
      arr << inited_room( room_type.id, amount, room_type.name)
    end
  end
  
  def get_room_type bookable_id, bookable_type
    if bookable_type == "RoomType"
      context.hotel.room_types.find bookable_id
    else
      context.hotel.packages.find(bookable_id).room_type
    end
  end
    
  def init_rows
    arr = []
    (Date.current.beginning_of_year.month..Date.current.month).to_a.each do |month|
      arr << uninited_month(month: date_for_month(month))
    end
    arr
  end
  
  def uninited_month( month: nil)
    OpenStruct.new date: month, rooms: []
  end
  
  def inited_room room_type_id, amount = 0.0, name = ""
    OpenStruct.new room_type_id: room_type_id, amount: amount, name: name
  end
  
  def date_for_month month
    Date.current.change( month: month, day: 1)
  end
  
end