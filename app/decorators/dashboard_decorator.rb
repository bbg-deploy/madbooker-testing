class DashboardDecorator < HotelDecorator
  
  
  def mobile_revenue_this_week
    
  end
  
  def tablet_revenue_this_week
    
  end
  
  def other_revenue_this_week
    
  end
  
  def revenue_this_week
    #o = mobile_other_total_from_group model.sales.range(Time.week).group(:mobile).paid.sum( :price)
  end
  
  def revenue_this_month
    #mobile_other_total_from_group model.sales.range(Time.month).group(:mobile).paid.sum( :price)
  end
  
  def revenue_daily_average
    #mobile_other_total_from_group model.sales.range(Time.month).group(:mobile).paid.average( :price)
  end
  
  def revenue_by_room_type
    Hotel::RevenueByRoomType.new(Context.new hotel: current_hotel, user: current_user).run
  end
  
  def searches_this_week
    #o = mobile_other_total_from_group model.stats.searches.range(Time.week).group(:mobile).count
    #link_to o, searches_hotel_reports_path(current_hotel, date_range: :month)
  end
  
  def searches_this_month
    #mobile_other_total_from_group searches_this_month_raw
  end
  
  def searches_daily_average
    x = searches_this_month_raw
    #mobile_other_total x[true].to_d/ Date.current.day, x[false].to_d/ Date.current.day
  end
  
  def look_to_book_week
    #mobile_other_average *look_to_book_ratio( model.stats.range(Time.week).group(:kind, :mobile).look_to_book.count)
  end
  
  def look_to_book_month
    #mobile_other_average *look_to_book_ratio( model.stats.range(Time.month).group(:kind, :mobile).look_to_book.count)    
  end
  
  def look_to_book_daily_average
    #m, o  = look_to_book_ratio( model.stats.range(Time.month).group(:kind, :mobile).look_to_book.count)    
    #mobile_other_average m/Date.current.day, o/Date.current.day    
  end
  
  
  private
  def look_to_book_ratio group
    [
      look_to_book_math( group[[Stat::LOOK, true]],  group[[Stat::BOOK, true]]),
      look_to_book_math( group[[Stat::LOOK, false]], group[[Stat::BOOK, false]])
    ]    
  end
  
  def look_to_book_math look, book
    look = look.to_d
    book = book.to_d
    if look == 0 || book == 0
      0
    else
      look / book
    end
  end
  
  def searches_this_month_raw
    model.stats.searches.range(Time.month).group(:mobile).count
  end
  
  def mobile_other_average mobile, other
    "Mobile: #{mobile}%, Other: #{other}%, Average: #{[mobile, other].average}%"
  end
  
  def mobile_other_total_from_group g
    mobile_other_total g[true], g[false]
  end
  
  def mobile_other_total mobile, other
    mobile = mobile.to_d
    other = other.to_d
    "Mobile: #{mobile}, Other: #{other}, Total: #{mobile + other}"
  end
  
  
end