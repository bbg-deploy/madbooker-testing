@module 'MB', ->
  @Forms = (->
    
    disable_readonly_when_deleted = ->
      $(document).on 'nested:fieldRemoved', (e)->
        e.field.find("input").removeAttr("required")
    
    init: ->
      disable_readonly_when_deleted()
  )()





  
