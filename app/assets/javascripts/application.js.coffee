#= require_self
#= require datepicker
#= require give_time
#= require tags
#= require_tree ./app

angular.module "timeoverflow", ["ng-rails-csrf", 'ui.bootstrap']

$(document).on 'click', 'a[data-popup]', (event) ->
  window.open($(this).attr('href'), 'popup', 'width=600,height=600')
  event.preventDefault()
