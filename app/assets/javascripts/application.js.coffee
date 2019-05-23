#= require give_time
#= require tags
#= require mobile_app_libs
#= require multi_select2

$(document).on 'click', 'a[data-popup]', (event) ->
  window.open($(this).attr('href'), 'popup', 'width=600,height=600')
  event.preventDefault()

$(document).on 'click', 'span.show-password', (event) ->
  if $(this).hasClass('checked')
    $(this).removeClass('checked');
    $(this).prev('input').attr('type', 'password');
    $(this).find('.material-icons').html("visibility")
  else
    $(this).addClass('checked');
    $(this).prev('input').attr('type', 'text');
    $(this).find('.material-icons').html("visibility_off")
  event.preventDefault()
