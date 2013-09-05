@module 'MB', ->
  @Setup = (->
    
    bind_selectors = ->
      $(document).on_and_off "change", "#link_look", ->
        update_examples()
      $(document).on_and_off "change", "#link_text", ->
        update_examples()
        
    update_examples = ->
      switch $("#link_look").val()
        when "Link" then link()
        when "Grey button" then grey()
        when "Green button" then green()
        when "Blue button" then blue()
        
    link = ->
      example "<a href='#{$("#booking_url").val()}' target='_blank'>#{$("#link_text").val()}</a>"
        
    grey = ->
      example "<a href='#{$("#booking_url").val()}' style='padding: 10px; background: #eee; border: 1px solid #999; color: #222; font-weight: bold;' target='_blank'>#{$("#link_text").val()}</a>"
        
    green = ->
      example "<a href='#{$("#booking_url").val()}' style='padding: 10px; background: green; border: 1px solid #999; color: white; font-weight: bold;' target='_blank'>#{$("#link_text").val()}</a>"
      
    blue =->
      example "<a href='#{$("#booking_url").val()}' style='padding: 10px; background: blue; border: 1px solid #999; color: white; font-weight: bold;' target='_blank'>#{$("#link_text").val()}</a>"
      
      
    example = (link)->
      $("#example").html link
      $("#example_text").text link
    
    init: ->
      bind_selectors()
  )()



