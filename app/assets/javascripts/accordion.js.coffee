@module 'MB', ->
  @Accordion = (->
    
    groups_selecot = "#content_selector"
    group_selector = ".steps"
    header_selector = ".step_header"
    content_selector = ".step_content"
    
    init_content_state = (dont_hide_index)->
      $(content_selector).hide()
      $($(content_selector)[dont_hide_index]).show()
    
    bind_headers = ->
      $(document).off_and_on "click", header_selector, (e)->
        header = $(e.currentTarget)
        if content_for(header).filter(":visible").size() == 0
          show_content header
          
    show_content = (header)->
      $(header_selector).each (i, o)->
        node = $(o)
        if node[0] == header[0]
          if content_for(header).filter(":visible").size() == 0
            show content_for( header)
        else if node.filter(":visible").size() > 0
          hide content_for( node)
          
    content_for = (header)->
      header.siblings(content_selector)
      
    hide = (content)->
      content.slideUp()
          
    show = (content)->
      content.slideDown()
      
    activate: (index)->
      $(content_selector).each (i,o)->
        node = $(o)
        if i == index
          show node if node.filter(":visible").size() == 0
        else if node.filter(":visible").size() > 0
          hide node
    
    init: ->
      init_content_state(0)
      bind_headers()
  )()





  



