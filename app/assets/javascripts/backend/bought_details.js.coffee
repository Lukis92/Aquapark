jQuery ->
    Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
    payment.setupForm()

payment =
    setupForm: ->
        $('#new_bought_detail').submit ->
            $('input[type=submit]').attr('disabled', true)
            Stripe.card.createToken($('#new_bought_detail'), payment.handleStripeResponse)
            false

    handleStripeResponse: (status, response) ->
        if status == 200
            $('#new_bought_detail').append($('<input type="hidden" name="stripeToken" />').val(response.id))
            $('#new_bought_detail')[0].submit()
        else
            $('#stripe_error').text(response.error.message).show()
            $('input[type=submit]').attr('disabled', false)
