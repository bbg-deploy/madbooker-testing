class CalendarDecorator < ApplicationDecorator
  
  def initialize(object, options = {})
    super
    self.class.delegate_all #some bug in draper not setting up delgation, i assume cuz this isn't AR::Base
  end
  
  def previous_month_link
    link_to previous_month.strftime('%B %Y'), for_month_hotel_inventories_path( hotel, previous_month.year, previous_month.month)
  end
  
  def next_month_link
    link_to next_month.strftime('%B %Y'), for_month_hotel_inventories_path( hotel, next_month.year, next_month.month)
  end


  def this_month_link
    link_to date.strftime('%B %Y'), for_month_hotel_inventories_path( hotel, date.year, date.month)
  end

  def for_year_link
    link_to "For #{date.year}", for_year_hotel_inventories_path( hotel, date.year)
  end

  def previous_year_link
    link_to "#{date.year-1}", for_year_hotel_inventories_path( hotel, date.year-1)
  end

  def next_year_link
    link_to "#{date.year+1}", for_year_hotel_inventories_path( hotel, date.year+1)
  end
  
end