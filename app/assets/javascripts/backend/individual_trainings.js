$("")
var payment;

var errorMessages = {
    incorrect_number: 'Numer karty jest nieprawidłowy.',
    invalid_number: 'Numer karty nie jest prawidłowy.',
    invalid_expiry_month: 'Termin wygaśnięcia karty jest nieprawidłowy.',
    invalid_expiry_year: 'Rok ważności karty jest nieprawidłowy.',
    invalid_cvc: 'Kod zabezpieczający kartę jest nieprawidłowy.',
    expired_card: 'Karta wygasła.',
    incorrect_cvc: 'Kod CVV jest nieprawidłowy.',
    incorrect_zip: 'Kod pocztowy karty jest nieprawidłowy.',
    card_declined: 'Karta została odrzucona.',
    missing: 'Nie ma karty na klienta, która jest w trakcie ładowania.',
    processing_error: 'Podczas przetwarzania karty wystąpił błąd.',
    rate_limit: 'Wystąpił błąd z powodu zbyt szybkiego przetwarzania wniosków API. Daj nam znać, jeśli błąd będzie stale występował.'
};

jQuery(function() {
    Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'));
    return payment.setupForm();
});

payment = {
    setupForm: function() {
        return $('#new_individual_training').submit(function() {
            $('input[type=submit]').attr('disabled', true);
            Stripe.card.createToken($('#new_individual_training'), payment.handleStripeResponse);
            return false;
        });
    },
    handleStripeResponse: function (status, response) {
        if (status === 200) {
            $('#new_individual_training').append($('<input type="hidden" name="stripeToken" />').val(response.id));
            return $('#new_individual_training')[0].submit();

        } else {
          if ( response.error && response.error.type == 'card_error'){
            $('#stripe_ind_error').text(errorMessages[response.error.code]).show();
          } else {
            $('#stripe_ind_error').text('Brak danych do płatności').show();
          }
            return $('input[type=submit]').attr('disabled', false);
        }
    }
};
