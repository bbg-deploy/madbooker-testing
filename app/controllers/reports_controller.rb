class ReportsController < ApplicationController
  
  def show
    render    
  end
  
  def searches
    @searches = current_hotel.stats.searches.range(date_range.to_r)
    render action: :show
  end
  
  def revenue
    @revenue = Reports::Revenue.new(context:context).run
  end
  
  def revenue_by_room_type
    
  end
  
  def daily
    @adr = Reports::AverageDailyRate.new(context).run
  end
  
  private
  def date_range
    @date_range ||= DateRange.from_params params
  end
end
