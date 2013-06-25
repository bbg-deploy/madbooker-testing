@module 'MB', ->
  @Book = (->
    
    #http://jquerycreditcardvalidator.com
    cc_state = {}
    
    setup_date_pickers = ->
      $( "#booking_arrive" ).datepicker {
        defaultDate: "+3d"
        changeMonth: true
        numberOfMonths: 2
        minDate: new Date()
        showAnim: "slideDown"
        onClose: ( selectedDate, o) ->
          $( "#booking_depart" ).datepicker "option", "minDate", new Date(o.selectedYear, o.selectedMonth, parseInt(o.selectedDay)+1)
        }
      $( "#booking_depart" ).datepicker {
        defaultDate: "+5d"
        changeMonth: true
        numberOfMonths: 2
        showAnim: "slideDown"
      }
      
    setup_credit_card_number_validator = ->
      $("#booking_cc_number").validateCreditCard (result)->
        cc_state = result
      
    setup_credit_card_validator = ->
      $("#checkout_form").off "submit"
      $("#checkout_form").on "submit", ->
        unless cc_state["luhn_valid"] && cc_state["length_valid"]
          alert "Your credit card number doesn't look right, can you double check it?"
          return false
        now = new Date()
        cc = new Date($("#booking_cc_year").val(), $("#booking_cc_month").val())
        if cc < now || $("#booking_cc_month").val().isBlank() || $("#booking_cc_year").val().isBlank()
          alert("Your credit card expiration date doesn't look right, can you double check it?")
          return false
    
    init: ->
      setup_date_pickers()
      setup_credit_card_number_validator()
      setup_credit_card_validator()
  )()





  
