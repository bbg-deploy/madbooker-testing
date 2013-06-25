@module 'MB', ->
  @Calendar = (->
    
    selection = []
    
    hightlight_form = ->
      $("#inventories_form").effect( "highlight")
      
    clear_selection = ->
      $(".day_selectable.selected").removeClass("selected")
    
    make_days_selectable = ->
      $(document).on "mousedown", '.day_selectable', (e)->
        selection = []
        clear_selection()
        e.preventDefault()
        selection.push $(e.currentTarget)
        selection[0].addClass "selected"
      
      $(document).on "mouseup", '.day_selectable', (e)->
        selection.push $(e.currentTarget)
        #p selection
        try
          $("#inventories_form").load form_hotel_inventories_path(MB.current_hotel_id, "html", {start: selection[0].data().date, end: selection[1].data().date}), "", hightlight_form
        catch er
          p er
          p e
          p selection
        selection = []
        
      $(document).on "mouseenter", '.day_selectable', (e)->
        return if selection.isEmpty()
        e.preventDefault()
        o = $(e.currentTarget)
        st = new Date(selection[0].data().date)
        en = new Date(o.data().date)
        if st > en
          en = st
          st = new Date(o.data().date)
        range = new DateRange st, en
        clear_selection()
        $(".day_selectable").each (i, item)->
          if range.contains new Date($(item).data().date)
            $(item).addClass "selected"
        
        o.addClass "selected"
        
        
    init: ->
      make_days_selectable()
  )()





  
