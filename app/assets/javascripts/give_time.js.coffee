jQuery.validator.addMethod "either-hours-minutes-informed", ((value, element) ->
  $("#transfer_hours").val() or $("#transfer_minutes").val()
), "Hours or minutes should be informed"

giveTimeReadyFn = () ->
  config =
    submitHandler: (form) ->
      amount = $("#transfer_hours").val() * 3600 + $("#transfer_minutes").val() * 60
      $("#transfer_amount").val(amount)

      if amount > 0
        form.submit()
      else
        $(form).find('.form-actions .error').removeClass('invisible').show()

  $( "#new_transfer" ).validate(config)

$(document).on "turbolinks:load", giveTimeReadyFn
