class ReportsController < ApplicationController
  
  def show
    render    
  end
  
  def searches
    #@searches = 
    render action: :show
  end
  
  private
  def date_range
    @date_range ||= DateRange.from_params params
  end
end
