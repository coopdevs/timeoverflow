$( document ).ready(function () {
  jQuery.validator.addMethod(
    "either-hours-minutes-informed",
    function (value, element) {
      return Boolean($("#transfer_hours").val() || $("#transfer_minutes").val());
    },
    "Hours or minutes should be informed"
  );

  // Prevent double submissions (double click, Enter pressed twice, slow
  // network...), which created duplicated transfers
  function lockForm(form) {
    if ($(form).data("submitting")) return false;

    $(form).data("submitting", true);
    $(form).find("button, input[type=submit]").prop("disabled", true);
    return true;
  }

  function submitHandler(form) {
    // just submit when fields are not visible, in order to not break the multi
    // transfer wizard
    if (!$("#transfer_hours").is(":visible")) {
      if (lockForm(form)) form.submit();
      return;
    }

    var amount = $("#transfer_hours").val() * 3600 + $("#transfer_minutes").val() * 60;
    $("#transfer_amount").val(amount);

    // at least one minute, in whole minutes (e.g. 0.5 minutes is not valid)
    if (!(amount >= 60) || amount % 60 !== 0) {
      $(form).find('.js-error-amount').removeClass('invisible').show();
      return;
    }

    if ($(form).valid() && lockForm(form)) {
      form.submit();
    }
  }

  // Unlock the form when coming back to the page from the browser history
  $(window).on("pageshow", function (event) {
    if (!event.originalEvent.persisted) return;

    $("#multi_transfer, #new_transfer").each(function () {
      $(this).data("submitting", false);
      $(this).find("button, input[type=submit]").prop("disabled", false);
    });
  });

  $("#multi_transfer, #new_transfer").validate({
    submitHandler: submitHandler
  });
})
