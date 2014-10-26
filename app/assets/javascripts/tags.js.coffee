# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on('click','.switch_offer',( ->
  $.ajax
    type: "GET"
    url: "/tags/alpha_grouped_index?post_type=offer"
    success: (data, textStatus, jqXHR) ->
      $('.alpha_tag_list').append('#{escape_javascript(render partial: "grouped_index", :locals => { :alpha_tags => @alpha_tags })}')
    error: (jqXHR, textStatus, errorThrown) ->
      $('.alpha_tag_list').append('AJAX Error: #{textStatus}')
));

$(document).on('click','.switch_inquiry',( ->
  $.ajax
    type: "GET"
    url: "/tags/alpha_grouped_index?post_type=inquiry"
    success: (data, textStatus, jqXHR) ->
      $('.alpha_tag_list').append('#{escape_javascript(render partial: "grouped_index", :locals => { :alpha_tags => @alpha_tags })}')
    error: (jqXHR, textStatus, errorThrown) ->
      $('.alpha_tag_list').append('AJAX Error: #{textStatus}')
));
