@module 'MB', ->
  @Hotel = (->
    
        
    set_subdomain = (sub)->
      return unless $("#hotel_subdomain").val().isBlank()
      s = sub.replace(/https?:\/\//, "").replace(/\s/, "-").replace(/[^a-z-]/gi, "").replace(/-+/g, "-")
      $("#hotel_subdomain").val s
      set_subdomain_hint()
      
    set_subdomain_hint = ->
      val = $("#hotel_subdomain").val()
      $("#hotel_subdomain").siblings(".hint").text "https://#{val}.madbooker.com"
      
    bind_url_field = ->
      $(document).off_and_on "blur", "#hotel_url", (e)->
        set_subdomain($(e.target).val())
        ensure_http()
        get_ga_code()
        
    ensure_http = ->
      val = $("#hotel_url").val()
      return if val.startsWith("http://") || val.startsWith("https://")
      $("#hotel_url").val("http://#{val}")
      
    bind_ga_help = ->
      $("#google_analytics_code_type_help_clicker").off_and_on "click", ->
        MB.Errors.show "Google Analytics", "
        Google Analytics now has two ways to add Google Analytics to your site. If you are using Google Analytics you are using one of these two methods.
        <br>
        <br>
        We need to figure out how someone can tell which one they use.
        "
        
    get_ga_code = ->
      return unless $("#hotel_google_analytics_code").val().isBlank()
      $.ajax ga_code_hotels_path("", {url: encodeURI($("#hotel_url").val())}), success: (data)->
        return if data.code.isBlank()
        $("#hotel_google_analytics_code").val data.code
        $("#hotel_google_analytics_code_type").val( if data.classic then "Classic Asynchronous" else "Universal Analytics").trigger("chosen:updated")

    init: ->
      bind_url_field()
      set_subdomain_hint()
      bind_ga_help()
  )()





  


