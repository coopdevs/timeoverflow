//= require_tree ./application

$(document).on('click', 'a[data-popup]', function(event) {
  event.preventDefault();

  window.open($(this).attr('href'), 'popup', 'width=800,height=600');
});

$(document).on('click', 'a[data-remote][data-bs-toggle="modal"]', async function(event) {
  event.preventDefault();
  const url = event.currentTarget.href;
  const target = event.currentTarget.dataset.bsTarget;
  const response = await fetch(url);
  const html = await response.text();

  document.querySelector(target).querySelector('.modal-content').innerHTML = html;
});

$(document).on('click', 'span.show-password', function(event) {
  event.preventDefault();

  var input = $(this).prev('input');
  var icon = $(this).find('.glyphicon');

  $(input).attr('type', input[0].type === 'password' ? 'text' : 'password');
  $(icon).toggleClass('glyphicon-eye-close');
  $(icon).toggleClass('glyphicon-eye-open');
});

$(function() {
  $("#select2").select2();
});
