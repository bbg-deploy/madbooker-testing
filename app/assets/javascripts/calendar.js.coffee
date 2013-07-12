@module 'MB', ->
  @Calendar = (->
    
    selection = {s: null, e: null, range: null, valid: false, tracking: false}
    
    hightlight_form = ->
      $("#inventories_form").effect( "highlight")
      
    clear_selected = ->
      $(".day_selectable.selected").removeClass("selected")
      
    to_date = (d)->
      if typeof d is "string"
        new Date(d)
      else
        d
        
    to_s = (d)->
      if typeof d is "string"
        d
      else
        d.toISOString().split("T").first()
    
    set_picker_dates = ->
      if is_valid()
        $("#date_start").val(to_s selection.s)
        $("#date_end").val(to_s selection.e)
      else
        $("#date_start").val(to_s selection.s) if selection.s
        $("#date_end").val(to_s selection.e) if selection.e
      
    set_start_date = (date, clear_end)->
      selection.s = to_date date
      if clear_end #click on cal
        selection.e = selection.s
        selection.range = range( selection.s, selection.e)
        selection.valid = true
        selection.tracking = true
        set_picker_dates()
        remove_form()
        select_dates(selection.range)
      else if is_valid() #input from datepicker
        set_picker_dates()
        load_form()
        selection.tracking = false
        select_dates selection.range
      
    set_end_date = (date)->
      selection.e = to_date(date)
      set_picker_dates()
      selection.tracking = false
      if is_valid()
        select_dates(selection.range) 
        load_form()

    select_dates = (r)->
      clear_selected()
      $(".day_selectable").each (i, item)->
        if r.contains to_date($(item).data().date)
          
          $(item).addClass "selected"        
        
      
    is_valid = ->
      return selection.valid = false if !selection.s or !selection.e
      #p selection
      r = range selection.s, selection.e
      selection.s = r.start
      selection.e = r.end
      selection.range = r
      selection.valid = true
      
    remove_form = ->
      $("#inventories_form").html("")
      
    load_form = ->
      return unless is_valid()
      try
        #err selection
        $("#inventories_form").load form_hotel_inventories_path(MB.current_hotel_id, "html", {start: to_s(selection.s), end: to_s(selection.e)}), "", hightlight_form
      catch er
        err er
        p selection
      
    range = (s, e)->
      st = to_date s
      en = to_date e
      if st > en
        en = st
        st = to_date e
      new DateRange st, en
    
    set_mouse_events = ->
      $(document).off_and_on "mousedown", '.day_selectable', (e)->
        e.preventDefault()
        set_start_date($(e.currentTarget).data().date, true)
      
      $(document).off_and_on "mouseup", '.day_selectable', (e)->
        e.preventDefault()
        set_end_date($(e.currentTarget).data().date)
        
      $(document).off_and_on "mouseenter", '.day_selectable', (e)->
        #return if selection.isEmpty() or selection.length is 2
        return unless selection.tracking
        e.preventDefault()
        o = $(e.currentTarget)
        r = range selection.s, o.data().date
        select_dates r
        # clear_selected()
        # $(".day_selectable").each (i, item)->
        #   if r.contains to_date($(item).data().date)
        #     $(item).addClass "selected"        
        # o.addClass "selected"
    
      
    setup_date_pickers = ->
      if $("#date_start").data().for_month
        changeMonth = changeYear = false
        numberOfMonths = 1
        maxDate = Date.create().endOfMonth()
        minDate = Date.create().beginningOfMonth()
      else
        changeMonth = changeYear = true
        numberOfMonths = 1
        maxDate = minDate = null
      $( "#date_start" ).datepicker {
        defaultDate: "+3d"
        changeMonth: changeMonth
        changeYear: changeYear
        numberOfMonths: numberOfMonths
        maxDate: maxDate
        minDate: minDate
        showAnim: "slideDown"
        dateFormat: "yy-mm-dd"
        onSelect: ( selectedDate, o) ->
          set_start_date selectedDate, false
        }
      $( "#date_end" ).datepicker {
        defaultDate: "+1d"
        changeMonth: changeMonth
        changeYear: changeYear
        numberOfMonths: numberOfMonths
        maxDate: maxDate
        minDate: minDate
        showAnim: "slideDown"
        dateFormat: "yy-mm-dd"
        onSelect: ( selectedDate, o) ->
          set_end_date selectedDate
        }
      
        
    init: ->
      set_mouse_events()
      setup_date_pickers()
  )()





  
