class CalendarDecorator < ApplicationDecorator
  
  def initialize(object, options = {})
    super
    self.class.delegate_all #some bug in draper not setting up delgation, i assume cuz this isn't AR::Base
  end
  
  def previous_year_link
    link_to hotel_inventory_path( hotel, date.year-1) do
      "<i class='icon-calendar'></i> #{date.year-1}".html_safe
    end
  end

  def next_year_link
    link_to hotel_inventory_path( hotel, date.year+1) do
      "<i class='icon-calendar'></i> #{date.year+1}".html_safe
    end
  end
  
end