class DashboardDecorator < HotelDecorator
  
  
  
  def revenue_this_week
    model.sales.range(week).paid.sum :rate
  end
  
  def revenue_this_month
    
  end
  
  def revenue_daily_average
    
  end
  
  
  private
  def week
    Time.zone.now.all_week
  end
  
  def month
    Time.zone.now.all_month
  end
  
end