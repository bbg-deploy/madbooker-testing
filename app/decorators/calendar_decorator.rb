class CalendarDecorator < ApplicationDecorator
  
  def initialize(object, options = {})
    super
    self.class.delegate_all #some bug in draper not setting up delgation, i assume cuz this isn't AR::Base
  end
  
  def previous_month_link
    link_to for_month_hotel_inventories_path( hotel, previous_month.year, previous_month.month) do
      "<i class='icon-calendar'></i> ".html_safe + previous_month.strftime('%B %Y')
    end
  end
  
  def next_month_link
    link_to for_month_hotel_inventories_path( hotel, next_month.year, next_month.month) do
      "<i class='icon-calendar'></i> ".html_safe + next_month.strftime('%B %Y')
    end
  end


  def this_month_link
    link_to date.strftime('%B %Y'), for_month_hotel_inventories_path( hotel, date.year, date.month)
  end

  def for_year_link
    link_to for_year_hotel_inventories_path( hotel, date.year) do
      "<i class='icon-calendar'></i> For #{date.year}".html_safe
    end
  end

  def previous_year_link
    link_to for_year_hotel_inventories_path( hotel, date.year-1) do
      "<i class='icon-calendar'></i> #{date.year-1}".html_safe
    end
  end

  def next_year_link
    link_to for_year_hotel_inventories_path( hotel, date.year+1) do
      "<i class='icon-calendar'></i> #{date.year+1}".html_safe
    end
  end
  
end