
class Inventory::Month
  attr_accessor :date, :hotel
  
  def initialize date, hotel
    self.date = date
    self.hotel = hotel
  end
  
  def previous_month
    date.advance months: -1
  end
  
  def next_month
    date.advance months: 1
  end
  
  def inventory_on date
    i = inventories.select {|i| i.date == date}
    return [] if i.blank?
    i
  end
  
  def inventories
    @inventories ||= hotel.inventories.for_month( date).all
  end
  
end