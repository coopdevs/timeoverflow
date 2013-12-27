jQuery.validator.addMethod "either-hours-minutes-informed", ((value, element) ->
  $("#transfer_hours").val() or $("#transfer_minutes").val()
), "Hours or minutes should be informed"

giveTimeReadyFn = () ->
  config =
    submitHandler: (form) ->
      $(" #transfer_amount ").val($(" #transfer_hours ").val() * 3600 + $(" #transfer_minutes ").val() * 60)
      form.submit()

  $( "#new_transfer" ).validate(config)

$( document ).ready giveTimeReadyFn
