window.module = (name, fn)->
  unless @[name]
    this[name] = {}
  unless @[name].module
    @[name].module = window.module
  try
    fn.apply(this[name], [])
  catch error
    console.error( error) if console