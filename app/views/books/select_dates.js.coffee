
<% if @available_rooms.blank? %>
  $("#step1 .message").text("Sorry, we don't have any rooms on those dates.")
  
<% end %> 
  <%= replace_with_partial "#step2", "/books/steps/step2" %>

