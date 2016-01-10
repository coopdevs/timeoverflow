$ ->
  $(".switch_offer-js").on "click", ->
    $.ajax '/tags/offers',
      type: 'GET'
      dataType: 'html'
      error: (jqXHR, textStatus, errorThrown) ->
          $('.alpha_tag_list').html "AJAX Error: #{textStatus}"
      success: (data, textStatus, jqXHR) ->
        $('.alpha_tag_list').html "#{data}"

  $(".switch_inquiry-js").on "click", ->
    $.ajax '/tags/inquiries',
      type: 'GET'
      dataType: 'html'
      error: (jqXHR, textStatus, errorThrown) ->
        $('.alpha_tag_list').html "AJAX Error: #{textStatus}"
      success: (data, textStatus, jqXHR) ->
        $('.alpha_tag_list').html "#{data}"

  $('#tags-js').select2
    tags: true
    tokenSeparators: [',']
    dataType: 'json'
    delay: 250
    ajax:
      url: '/tags.json'
      data: (params) ->
        term: params.term
      processResults: (data, params) ->
        # parse the data into the format expected by Select2
        results: $.map(data, (item) ->
          id: item
          text: item
        )
