@module 'MB', ->
  @Booking = (->
    
    setup_day_picker = ->
      $( "#daypicker" ).datepicker {
        dateFormat: "yy-mm-dd"
        changeMonth: true
        changeYear: true
        onSelect: ( selectedDate, o) -> 
          Turbolinks.visit hotel_bookings_path(MB.current_hotel_id, "html", {date: selectedDate})
        }
      $( "#daypicker" ).datepicker "setDate", new URI().search(true).date
        
      
    init: ->
      setup_day_picker()
  )()





  
