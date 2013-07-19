class DashboardDecorator < HotelDecorator
  
  
  
  def revenue_this_week
    model.sales.range(Time.week).paid.sum :price
  end
  
  def revenue_this_month
    model.sales.range(Time.month).paid.sum :price
  end
  
  def revenue_daily_average
    model.sales.range(Time.month).paid.average :price
  end
  
  def revenue_by_room_type
    Hotel::RevenueByRoomType.new(Context.new hotel: current_hotel, user: current_user).run
  end
  
  
  private
  
end