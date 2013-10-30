@module 'MB', ->
  @Errors = (->
    
    
    show_error_box = (title, msg)->
      $("#dialog-message").dialog( {
        title: title
        buttons: [ 
          { 
            text: "OK", 
            click: -> $( @ ).dialog( "close" )
          } 
          ]
        closeOnEscape: false
      }).html msg
      
      clear_error()
      
    clear_error = ->
      location.hash = ""
      
      
      
    handle_error_499: ->
      show_error_box "Error", "That room is no longer available for those dates.<br/>Please search again."
      
    
    show: (title, msg)->
      show_error_box title, msg

    init: ->
      frag = new URI().fragment()
      if frag
        kv = frag.split("=")
        k = kv[0]
        v = kv[1]
        return unless k == "error"
        @["handle_error_#{v}"].apply()
  )()





  


