@module 'MB', ->
  @Stripe = (->
    
    bind_form = ->
      $("#sign_up_button").on "click", ->
        if (new URI().domain() == "madbooker.com")
          Stripe.setPublishableKey('pk_live_aLgf5DdedLp3s9FwpULfdz6W')
        else
          Stripe.setPublishableKey('pk_test_ltJDWo0zaOhl7t6Kcq6zffhJ')
        Stripe.card.createToken {
          number:     $('#user_cc_number').val(),
          cvc:        $('#user_cc_cvv').val(),
          exp_month:  $('#user_cc_month').val(),
          exp_year:   $('#user_cc_year').val()
        }, stripe_response_handler
          
          
    stripe_response_handler = (status, response)->
      if (response.error)
        MB.Errors.show "Credit Card Error", response.error.message
      else
        $("#user_stripe_token").val response["id"]
        $("#user_cc_number").val ""
        $("#user_cc_cvv").val ""
        $("#signup_form").submit()
    
    init: ->
      bind_form()
  )()





  



