@module 'MB', ->
  @CheckIns = (->
    
    setup_calendar = ->
      $( "#date_picker" ).datepicker {
        dateFormat: "yy-mm-dd"
        changeMonth: true
        changeYear: true
        onSelect: ( selectedDate, o) -> 
          Turbolinks.visit hotel_check_ins_path(MB.current_hotel_id, "html", {date: selectedDate})
        }
      $( "#date_picker" ).datepicker "setDate", url_date_or_today()
        
    url_date_or_today =->
      d = new URI().search(true).date
      d ?= new Date()
      
    init: ->
      setup_calendar()
  )()





  
