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
    x = model.stats.searches.range(Time.week).group(:mobile).count
    "Mobile: #{x[true]}, Other: #{x[false]}"
  end
  
  def searches_this_month
    x = searches_this_month_raw
    "Mobile: #{x[true]}, Other: #{x[false]}"
  end
  
  def searches_daily_average
    x = searches_this_month_raw
    "Mobile: #{x[true]/ Date.current.day}, Other: #{x[false]/ Date.current.day}"
  end
  
  
  private
  def searches_this_month_raw
    model.stats.searches.range(Time.month).group(:mobile).count
  end
  
end