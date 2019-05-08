$( document ).ready(function () {
  jQuery.validator.addMethod(
    "either-hours-minutes-informed",
    function (value, element) {
      return Boolean($("#transfer_hours").val() || $("#transfer_minutes").val());
    },
    "Hours or minutes should be informed"
  );

  function submitHandler(form) {
    // just submit when fields are not visible, in order to not break the multi
    // transfer wizard
    if (!$("#transfer_hours").is(":visible")) {
      form.submit();
      return;
    }

    var amount = $("#transfer_hours").val() * 3600 + $("#transfer_minutes").val() * 60;
    $("#transfer_amount").val(amount);

    if (amount == 0) {
      $(form).find('.js-error-amount').removeClass('invisible').show();
      return;
    }

    if ($(form).valid()) {
      form.submit();
    }
  }

  var config = {
    submitHandler: submitHandler
  };

  $("#multi_transfer, #new_transfer").validate(config);
})
