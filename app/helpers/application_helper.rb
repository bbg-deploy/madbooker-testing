module ApplicationHelper
  
  def hotel_link
    return link_to( "Create your hotel", new_hotel_path) if current_hotel.blank?
    link_to current_hotel do
      "<i class='icon-dashboard'></i> Dashboard".html_safe
      end
  end
  
  def replace_with_partial(dom_el, partial)
    "$('#{dom_el}').replaceWith('#{escape_javascript(render(partial))}')".html_safe
  end
  
  def replace_content_with_partial(dom_el, partial)
    "$('#{dom_el}').html('#{escape_javascript(render(partial))}')".html_safe
  end
  
  def bookables
    a = []
    current_hotel.room_types.decorate.each do |room_type|
      a << room_type
      a << room_type.packages.active.decorate
    end
    a.flatten
  end
  
  def format value = nil, type: nil
    return "" unless value
    return send "format_#{type}", value if type
    return value if value.is_a? String
    send "format_#{value.class.to_s.underscore.gsub("/", "_")}", value
  end
  
  def format_date val
    val.strftime "%b %d, %y"
  end
  
  def format_big_decimal val
    number_to_currency val, unit: current_hotel.currency.html_symbol
  end
  
  def format_float val
    format_big_decimal val.to_d
  end
  
  def format_for_dash val
    val.to_i
  end
  
  def format_active_support_time_with_zone val
    val.strftime "%b %d, %y %I:%M%p"
  end
  

end
