$ ->
  $("input.datepicker").each (i) ->
    $(this).datepicker
      altFormat: "dd-mm-yy"
      dateFormat: "dd/mm/yy"
      altField: $(this).next()
  $("#datepicker_from, #datepicker_to").datepicker
    changeMonth: true
    changeYear: true
    showButtonPanel: true
    dateFormat: "MM yy"
    onClose: ->
      month = $("#ui-datepicker-div .ui-datepicker-month :selected").val()
      year = $("#ui-datepicker-div .ui-datepicker-year :selected").val()
      $(this).datepicker "setDate", new Date(year, month, 1)
      return    
  $("#datepicker_from, #datepicker_to").focus ->
    $(".ui-datepicker-calendar").hide()
    return

