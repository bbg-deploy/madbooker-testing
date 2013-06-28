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
        defaultDate: "+1d"
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
          
    setup_tabs = ->
      $( "#checkout_tabs" ).tabs(
          beforeActivate: ( event, ui )->
            copy_and_remove ui.oldPanel.selector, ui.newPanel.selector
        )
        
    copy_and_remove = (from, to)->
      guest = "#for_other .guest"
      first = $("#booking_first_name").val()
      last  = $("#booking_last_name").val()
      email = $("#booking_email").val()
      if to == "#for_other"
        $(guest).html($(from).html())
        $(from).html("")
        guestify_labels()
      else
        $(to).html($(guest).html())
        $(guest).html("")
        unguestify_labels()
      $("#booking_first_name").val(first)
      $("#booking_last_name").val(last)
      $("#booking_email").val(email)

    unguestify_labels = ->
      guestifying_labels("abbr> Guest's", "abbr>")

    guestifying_labels = (from, to)->
      ["first_name", "last_name", "email"].each (o, i)->
        html = $("label[for='booking_#{o}']").html()
        $("label[for='booking_#{o}']").html(html.replace(from, to))

    guestify_labels = ->
      guestifying_labels("abbr>", "abbr> Guest's")
    
    init: ->
      setup_date_pickers()
      setup_credit_card_number_validator()
      setup_credit_card_validator()
      setup_tabs()
  )()





  
