class Cron::LowInventory < Less::Interaction
  
  
  attr_accessor :inventories
  
  def run
    @stats = OpenStruct.new hotels: 0, inventories: 0, details: []
    User.paying.find_each do |user|
      find_inventories_and_send_notification user
    end
    @stats
  end
  
  private
  
  def find_inventories_and_send_notification user
    hotel = user.hotels.first
    threshold = hotel.minimal_inventory_notification_threshold
    inventories = hotel.inventories.past_threshold(threshold).next_30_days
    return if inventories.blank?
    @stats.hotels += 1
    @stats.inventories += inventories.count
    @stats.details << OpenStruct.new(hotel: hotel.id, inventories: inventories.count)
    send_emails hotel, inventories
  end
  
  def send_emails hotel, inventories
    LowInventoryMailer.low_inventory(hotel, inventories).deliver
  end

end