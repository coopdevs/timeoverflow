jQuery ->
  $('#offer_tag_list').typeahead({
    hint: true,
    highlight: true,
    minLength: 1
  },
  {
    name: 'tags',
    displayKey: 'value',
    source: ['foo','food','four']
  });
