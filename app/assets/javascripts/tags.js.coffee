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
