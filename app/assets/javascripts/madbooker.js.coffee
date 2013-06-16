@MB ?= {}

  
@MB.dont_init = ->
  false
  
@MB.execute_submodules = (obj)->
  for own name, module of obj
    if Object.has(module, "precondition") and !module.precondition()
      continue 
    if Object.has(module, "inited") and module.inited
      continue 
    module.init() if Object.isObject(module) and Object.has(module, 'init')

@MB.init =->
  #$(document).off 'nested:fieldAdded'
  #$(document).off 'nested:fieldRemoved'
  @execute_submodules(this)
