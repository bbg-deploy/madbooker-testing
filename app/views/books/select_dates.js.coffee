  <%= replace_with_partial "#step2", "/books/steps/step2" %>
  <%= replace_with_partial "#step3", "/books/steps/step3" %>

<% if @available_rooms.blank? %>
  $("#step1 .message").text("Sorry, we don't have any rooms on those dates.")
<% else %>
  $("#step1 .message").text("")
  MB.Accordion.activate 1
<% end %> 

