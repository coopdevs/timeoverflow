$(function() {
  $(document).on('change', '.organization-checkbox', function() {
    var searchParams = new URLSearchParams(window.location.search);
    var cat = searchParams.get('cat');
    var q = searchParams.get('q');
    var tag = searchParams.get('tag');
    
    var form = $(this).closest('form');
    
    if (cat) {
    if (form.find('input[name="cat"]').length === 0) {
      form.append('<input type="hidden" name="cat" value="' + cat + '">');
    }
    }
    
    if (q) {
    form.find('input[name="q"]').val(q);
    }
    
    if (tag) {
    if (form.find('input[name="tag"]').length === 0) {
      form.append('<input type="hidden" name="tag" value="' + tag + '">');
    }
    }
    
    form.submit();
  });
  });
