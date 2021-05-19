//= require_tree ./application
//= require leaflet

$(document).on('click', 'a[data-popup]', function(event) {
  event.preventDefault();

  window.open($(this).attr('href'), 'popup', 'width=800,height=600');
});

$(document).on('click', 'span.show-password', function(event) {
  event.preventDefault();

  var inputType = 'text';
  var icon = 'visibility_off';

  if ($(this).hasClass('checked')) {
    $(this).removeClass('checked');
    inputType = 'password';
    icon = 'visibility';
  } else {
    $(this).addClass('checked');
  }

  $(this).prev('input').attr('type', inputType);
  $(this).find('.material-icons').html(icon);
});

$(function() {
  $("#select2").select2();
});
