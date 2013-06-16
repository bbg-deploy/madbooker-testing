class CalendarDecorator < ApplicationDecorator
  
  def initialize(object, options = {})
    super
    self.class.delegate_all #some bug in draper not setting up delgation, i assume cuz this isn't AR::Base
  end
  
  def previous_month_link
    link_to previous_month.strftime('%B %Y'), for_date_hotel_inventories_path( hotel, previous_month.year, previous_month.month)
  end
  
  def next_month_link
    link_to next_month.strftime('%B %Y'), for_date_hotel_inventories_path( hotel, next_month.year, next_month.month)
  end
  
  def info_for date
    
  end
  
end