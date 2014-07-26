CreditCard =
  cleanNumber: (number) -> number.replace /[- ]/g, ""

  validNumber: (number) ->
    total = 0
    number = @cleanNumber(number)
    for i in [(number.length-1)..0]
      n = +number[i]
      if (i+number.length) % 2 == 0
        n = if n*2 > 9 then n*2 - 9 else n*2
      total += n
    total % 10 == 0

ready = ->

  $(document.body).on "click", ".profile-selector", ->
    id = $(this).val()
    $("#payment-profile-id").val(id)

  $(document.body).on "blur", "input#payment_profile_cc_number", ->

    if CreditCard.validNumber(@value)
      $("#cc_number_error").text("")
    else
      $("#cc_number_error").text("Invalid credit card number")

$(document).ready(ready)
$(document).on('page:load', ready)