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
        $(form).find('input:submit').after(' <label class="error">Time must be greater than 0</label>')

  $( "#new_transfer" ).validate(config)

$( document ).ready giveTimeReadyFn
