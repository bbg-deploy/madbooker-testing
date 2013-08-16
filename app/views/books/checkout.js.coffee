
<%if @result.success?%>
  Turbolinks.visit "<%=booking_path(@result.object.booking.guid)%>"
<% elsif @result.status == Booking::Reserve::DATES_NOT_AVAILABLE %>
  Turbolinks.visit "<%= book_path(anchor: "error=499") %>"
<% else %>
<%= replace_with_partial "#step3", "/books/steps/step3" %>

MB.Tabs.init()
MB.Select.init()
MB.Book.init()

<% end %>
