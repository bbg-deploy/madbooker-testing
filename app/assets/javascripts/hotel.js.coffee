@module 'MB', ->
  @Hotel = (->
    
    bind_name_field = ->
      $(document).off_and_on "blur", "#hotel_name", (e)->
        set_subdomain($(e.target).val())
        
    set_subdomain = (sub)->
      return unless $("#hotel_subdomain").val().isBlank()
      s = sub.replace(/\s/, "-").replace(/[^a-z-]/gi, "").replace(/-+/g, "-")
      $("#hotel_subdomain").val s
      set_subdomain_hint()
      
    set_subdomain_hint = ->
      val = $("#hotel_subdomain").val()
      $("#hotel_subdomain").siblings(".hint").text "https://#{val}.madbooker.com"
      
    bind_url_field = ->
      $(document).off_and_on "blur", "#hotel_url", (e)->
        ensure_http()
        
    ensure_http = ->
      val = $("#hotel_url").val()
      return if val.startsWith("http://") || val.startsWith("https://")
      $("#hotel_url").val("http://#{val}")

    init: ->
      bind_url_field()
      bind_name_field()
      set_subdomain_hint()
  )()





  


