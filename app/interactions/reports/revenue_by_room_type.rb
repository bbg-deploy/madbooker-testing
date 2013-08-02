class Reports::RevenueByRoomType < Less::Interaction
  
  
  def run
    self
  end
  
  def revenue
    @revenue ||= fill_data(get_revenue_data).log.to_json
  end
  
  def booking
    @booking ||= fill_data(get_booking_data).to_json
  end
  
  private 
  def get_revenue_data
    context.hotel.sales.range(Date.year).joins(:booking).group("bookings.bookable_id, bookings.bookable_type", "month(date)").paid.sum( :price)
  end
  
  def get_booking_data
    context.hotel.sales.range(Date.year).joins(:booking).group("bookings.bookable_id, bookings.bookable_type", "month(date)").paid.count
  end
  
  def fill_data input
    input.log
    out = init_rows
    input.each do |datum|
      room_type_id = datum[0][0]
      month = date_for_month datum[0][1]
      amount = datum[1]
      row = out.select{|x| x.date == month}.first
      fill_room_data row.rooms, room_type_id: room_type_id, amount: amount
    end
    #assign_totals out
    out
  end
  
  def fill_room_data arr, room_type_id: room_type_id, amount: amount
    arr << inited_room( room_type_id, amount)
  end
  
  def assign_totals arr
    arr.each {|d| d.total = d.mobile + d.other}
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
  
  def inited_room room_type_id, amount = 0.0
    OpenStruct.new room_type_id: room_type_id, amount: amount#, name: context.hotel.room_types.find(room_type_id).name
  end
  
  def date_for_month month
    Date.current.change( month: month, day: 1)
  end
  
end