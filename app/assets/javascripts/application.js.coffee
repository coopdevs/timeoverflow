# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery_ujs
#= require_self
#= require datepicker
#= require give_time
#= require tags
#= require ui-bootstrap-tpls-0.11.0
#= require_tree ./modules
#= require_tree ./app

angular.module "timeoverflow", ["ng-rails-csrf", 'ui.bootstrap']

$(document).on 'click', 'a[data-popup]', (event) ->
  window.open($(this).attr('href'), 'popup', 'width=600,height=600')
  event.preventDefault()
