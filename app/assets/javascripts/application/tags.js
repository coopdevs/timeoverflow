$(function() {
  $(".switch_offer-js").on("click", function() {
    loadTags('offer');
  });

  $(".switch_inquiry-js").on("click", function() {
    loadTags('inquiry');
  });

  $(".switch_member-js").on("click", function() {
    loadTags('user');
  });

  function loadTags(type){
    $.get({
      url: `/tags/alpha_grouped_index.js?post_type=${type}`,
      dataType: 'html',
      error: function(jqXHR, textStatus, errorThrown) {
        $('.alpha_tag_list').html('AJAX Error: ' + textStatus);
      },
      success: function(data, textStatus, jqXHR) {
        $('.alpha_tag_list').html(data);
      }
    });
  }

  $('#tags-js').select2({
    tags: true,
    tokenSeparators: [','],
    dataType: 'json',
    delay: 250,
    ajax: {
      url: '/tags.json',
      data: function(params) {
        return { term: params.term, model: $(this).data("model") };
      },
      processResults: function(data, params) {
        // parse the data into the format expected by Select2
        return {
          results: $.map(data, item => ({
            id: item,
            text: item
          }))
        };
      }
    }
  });
});
