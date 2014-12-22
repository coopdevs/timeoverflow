# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "click", ".switch_offer", (event) ->
  $.ajax '/tags/offers',
    type: 'GET'
    dataType: 'html'
    error: (jqXHR, textStatus, errorThrown) ->
        $('.alpha_tag_list').html "AJAX Error: #{textStatus}"
      success: (data, textStatus, jqXHR) ->
        $('.alpha_tag_list').html "#{data}"

$(document).on "click", ".switch_inquiry", (event) ->
  $.ajax '/tags/inquiries',
      type: 'GET'
      dataType: 'html'
      error: (jqXHR, textStatus, errorThrown) ->
          $('.alpha_tag_list').html "AJAX Error: #{textStatus}"
      success: (data, textStatus, jqXHR) ->
          $('.alpha_tag_list').html "#{data}"

$(document).on "click", ".switch_offer_destroy", (event) ->
  $.ajax '/tags/destroy_offers',
    type: 'GET'
    dataType: 'html'
    error: (jqXHR, textStatus, errorThrown) ->
        $('.alpha_tag_list').html "AJAX Error: #{textStatus}"
      success: (data, textStatus, jqXHR) ->
        $('.alpha_tag_list').html "#{data}"

$(document).on "click", ".switch_inquiry_destroy", (event) ->
  $.ajax '/tags/destroy_inquiries',
      type: 'GET'
      dataType: 'html'
      error: (jqXHR, textStatus, errorThrown) ->
          $('.alpha_tag_list').html "AJAX Error: #{textStatus}"
      success: (data, textStatus, jqXHR) ->
          $('.alpha_tag_list').html "#{data}"

$(document).on "click", ".switch_offer_rename", (event) ->
  $.ajax '/tags/rename_offers',
    type: 'GET'
    dataType: 'html'
    error: (jqXHR, textStatus, errorThrown) ->
        $('.alpha_tag_list').html "AJAX Error: #{textStatus}"
      success: (data, textStatus, jqXHR) ->
        $('.alpha_tag_list').html "#{data}"

$(document).on "click", ".switch_inquiry_rename", (event) ->
  $.ajax '/tags/rename_inquiries',
      type: 'GET'
      dataType: 'html'
      error: (jqXHR, textStatus, errorThrown) ->
          $('.alpha_tag_list').html "AJAX Error: #{textStatus}"
      success: (data, textStatus, jqXHR) ->
          $('.alpha_tag_list').html "#{data}"    
      