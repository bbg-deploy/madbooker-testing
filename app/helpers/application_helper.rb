module ApplicationHelper
  
  def hotel_link
    return link_to( "Create your hotel", new_hotel_path) if current_hotel.blank?
    link_to current_hotel.name, [:edit, current_hotel]
  end
end
