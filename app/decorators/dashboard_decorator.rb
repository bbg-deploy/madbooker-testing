class DashboardDecorator < HotelDecorator
  
  
  def mobile_revenue_this_month
    revenue_this_month "mobile"
  end
  
  def tablet_revenue_this_month
    revenue_this_month "table"
  end
  
  def other_revenue_this_month
    revenue_this_month "desktop"
  end
  
  def total_revenue_this_month
    mobile_revenue_this_month + tablet_revenue_this_month + other_revenue_this_month
  end
  
  def mobile_revenue_last_month
    revenue_last_month "mobile"
  end
  
  def tablet_revenue_last_month
    revenue_last_month "table"
  end
  
  def other_revenue_last_month
    revenue_last_month "desktop"
  end
  
  def total_revenue_last_month
    mobile_revenue_last_month + tablet_revenue_last_month + other_revenue_last_month
  end
  
  def mobile_search_this_week
    @mobile_search_this_week ||= searches_by_range_and_device Time.week, :mobile
  end
  
  def tablet_search_this_week
    @tablet_search_this_week ||= searches_by_range_and_device Time.week, :tablet
  end
  
  def other_search_this_week
    @other_search_this_week ||= searches_by_range_and_device Time.week, :desktop
  end
  
  def total_search_this_week
    mobile_search_this_week + tablet_search_this_week + other_search_this_week
  end
  
  def mobile_search_this_month
    @mobile_search_this_month ||= searches_by_range_and_device Time.month, :mobile
  end
  
  def tablet_search_this_month
    @tablet_search_this_month ||= searches_by_range_and_device Time.month, :tablet
  end
  
  def other_search_this_month
    @other_search_this_month ||= searches_by_range_and_device Time.month, :desktop
  end
  
  def total_search_this_month
    mobile_search_this_month + tablet_search_this_month + other_search_this_month
  end
  
  def mobile_search_daily_average
    @mobile_search_daily_average ||= (mobile_search_this_month / Date.current.day).round(1)
  end
  
  def tablet_search_daily_average
    @tablet_search_daily_average ||= (tablet_search_this_month / Date.current.day).round(1)
  end
  
  def other_search_daily_average
    @other_search_daily_average ||= (other_search_this_month / Date.current.day).round(1)
  end
  
  def total_search_daily_average
    @total_search_daily_average ||= (total_search_this_month / Date.current.day).round(1)
  end
  
  def revenue_by_room_type
   Hotel::RevenueByRoomType.new(Context.new hotel: current_hotel, user: current_user).run
  end
  
  def mobile_look_to_book_this_week
     @mobile_look_to_book_this_week ||= look_to_book_ratio( model.stats.range(Time.week).group(:kind).where(device_type: "mobile").look_to_book.count)
  end

  def tablet_look_to_book_this_week
     @tablet_look_to_book_this_week ||= look_to_book_ratio( model.stats.range(Time.week).group(:kind).where(device_type: "tablet").look_to_book.count)
  end
  
  def other_look_to_book_this_week
     @other_look_to_book_this_week ||= look_to_book_ratio( model.stats.range(Time.week).group(:kind).where(device_type: "desktop").look_to_book.count)
  end
  
  def total_look_to_book_this_week
    @total_look_to_book_this_week ||= mobile_look_to_book_this_week + tablet_look_to_book_this_week + other_look_to_book_this_week
  end
  
  def mobile_look_to_book_this_month
     @mobile_look_to_book_this_week ||= look_to_book_ratio( model.stats.range(Time.month).group(:kind).where(device_type: "mobile").look_to_book.count)
  end
  
  def tablet_look_to_book_this_month
     @tablet_look_to_book_this_month ||= look_to_book_ratio( model.stats.range(Time.month).group(:kind).where(device_type: "tablet").look_to_book.count)
  end
  
  def other_look_to_book_this_month
     @other_look_to_book_this_month ||= look_to_book_ratio( model.stats.range(Time.month).group(:kind).where(device_type: "desktop").look_to_book.count)
  end
  
  def total_look_to_book_this_month
    @total_look_to_book_this_month ||= mobile_look_to_book_this_month + tablet_look_to_book_this_month + other_look_to_book_this_month
  
  end
  def mobile_look_to_book_daily_average
    @mobile_look_to_book_daily_average ||= (mobile_look_to_book_this_month / Date.current.day).round(1)
  end
  
  def tablet_look_to_book_daily_average
    @tablet_look_to_book_daily_average ||= (tablet_look_to_book_this_month / Date.current.day).round(1)
  end
  
  def other_look_to_book_daily_average
    @other_look_to_book_daily_average ||= (other_look_to_book_this_month / Date.current.day).round(1)
  end
  
  def total_look_to_book_daily_average
    @total_look_to_book_daily_average ||= (mobile_look_to_book_this_month + tablet_look_to_book_this_month + other_look_to_book_this_month / Date.current.day).round(1)
  end
  
  
  private  
  def searches_by_range_and_device range, device
    model.stats.searches.range(range).where("device_type = ?", device).count
  end
    
  def revenue_this_month type
    grouped_revenue_this_month[type] || 0.0
  end
  
  def revenue_last_month type
    grouped_revenue_last_month[type] || 0.0
  end

  def grouped_revenue_this_month
  @grouped_revenue_this_month ||= grouped_revenue_based_on_range Time.month
  end
  
  def grouped_revenue_last_month
    @grouped_revenue_this_month ||= grouped_revenue_based_on_range(Time.current.last_month.beginning_of_month..Time.current.last_month.end_of_month)
  end
  
  def grouped_revenue_based_on_range range
    model.sales.range(range).group(:device_type).paid.sum( :price)
  end
    
  def look_to_book_ratio group
    look_to_book_math( group[Stat::LOOK],  group[Stat::BOOK])
  end
  
  def look_to_book_math look, book
    look = look.to_d
    book = book.to_d
    if look == 0 || book == 0
      0
    else
      (look / book).round(1)
    end
  end
  
  
  
end