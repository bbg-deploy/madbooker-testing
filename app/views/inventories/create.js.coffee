

<% if resp.success? %>
  Turbolinks.visit hotel_inventories_path(MB.current_hotel_id)
  Notify "Inventory updated."
<%else%>
  <%= replace_content_with_partial "#inventories_form", "/inventories/calendar/form" %>
<%end%>
