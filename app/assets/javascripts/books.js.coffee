@module 'MB', ->
  @Book = (->
    
    setup_date_pickers = ->
      $( "#booking_arrive" ).datepicker {
        defaultDate: "+3d"
        changeMonth: true
        numberOfMonths: 2
        minDate: new Date()
        showAnim: "slideDown"
        onClose: ( selectedDate ) ->
          $( "#booking_depart" ).datepicker "option", "minDate", selectedDate 
        }
      $( "#booking_depart" ).datepicker {
        defaultDate: "+5d"
        changeMonth: true
        numberOfMonths: 2
        showAnim: "slideDown"
      }
    
    init: ->
      setup_date_pickers()
  )()





  
