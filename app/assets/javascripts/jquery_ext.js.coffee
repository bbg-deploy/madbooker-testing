$.fn.extend

    
  off_and_on: (event_name, selector, data, fn) ->
    if arguments.length is 2
      fn = selector
      selector = null
    if arguments.length is 3
      fn = data
      data = null      
    # err types
    # p selector
    # p data
    # p fn
    # p this
    $(this).off(event_name, selector).on(event_name, selector, data, fn)

  on_and_off: (event_name, selector, data, fn)->
    $(document).off_and_on event_name, selector, data, fn
