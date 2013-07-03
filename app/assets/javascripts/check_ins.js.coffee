@module 'MB', ->
  @CheckIns = (->
    
    setup_calendar = ->
      $( "#date_picker" ).datepicker {
        dateFormat: "yy-mm-dd"
        changeMonth: true
        changeYear: true
        onSelect: ( selectedDate, o) -> 
          Turbolinks.visit new URI().removeQuery("date").addQuery("date", selectedDate).readable()
#          hotel_check_ins_path(MB.current_hotel_id, "html", {date: selectedDate})
        }
      $( "#date_picker" ).datepicker "setDate", url_date_or_today()
        
    url_date_or_today =->
      d = new URI().search(true).date
      d ?= new Date()
      
      
    #used on checkins and and no shows
    init: ->
      setup_calendar()
  )()





  
