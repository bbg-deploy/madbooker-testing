@module 'MB', ->
  @Logger = (->

    log_on = true

    log: (msg, force)->
      if (log_on or force) and console?
        console.log msg 
      msg
    
    err: (msg)->
      if log_on and console?
        console.error msg
      msg
        
    logit: (bool)->
      log_on = bool
  
    )()
  
window.err = MB.Logger.err
window.log = MB.Logger.log
window.p = (msg)-> log(msg, true)
window.puts = p
  
  