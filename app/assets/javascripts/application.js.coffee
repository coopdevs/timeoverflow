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
#= require dataTables.bootstrap
#  require jquery.dataTables
#= require_self
# require turbolinks
#= require_tree .

$(document).ready -> $(".select2").select2()

$(document).bind 'page:load', -> $(".select2").select2()

$(document).on 'click', 'a[data-popup]', (event) ->
  window.open($(this).attr('href'), 'popup', 'width=600,height=600')
  event.preventDefault()



$(document).on "click", "#bulk-add-offers", (event) ->
  userId = $(event.currentTarget).attr("data-user-id")
  console.log event.currentTarget, userId
  $("#offers-bulk-modal").modal
    remote: '/offers?for_user=' + userId

$(document).on "click", ".join-post", (event) ->
  id = $(event.target).closest("li.post").attr("data-post-id")
  userId = $(event.target).closest("li.post").attr("data-user-id")
  $.ajax("/user/#{userId}/joined/#{id}", type: "POST")

$(document).on "click", ".leave-post", (event) ->
  id = $(event.target).closest("li.post").attr("data-post-id")
  userId = $(event.target).closest("li.post").attr("data-user-id")
  $.ajax("/user/#{userId}/joined/#{id}", type: "DELETE")

