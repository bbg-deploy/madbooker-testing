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
  
  def searches_this_week
    model.stats.searches.range(Time.week).count
  end
  
  def searches_this_month
    model.stats.searches.range(Time.month).count
  end
  
  def searches_daily_average
    searches_this_month / Date.current.day
  end
  
  
  private
  
end