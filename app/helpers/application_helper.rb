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

end
