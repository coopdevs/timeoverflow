// app/assets/javascripts/application/organization_filter.js
$(function() {
    // Manejar cambios en las casillas de organizaciones
    $(document).on('change', '.organization-checkbox', function() {
      // Obtener valores actuales de la URL
      var searchParams = new URLSearchParams(window.location.search);
      var cat = searchParams.get('cat');
      var q = searchParams.get('q');
      var tag = searchParams.get('tag');
      
      var form = $(this).closest('form');
      
      // Mantener parámetros actuales
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
      
      // Enviar el formulario
      form.submit();
    });
  });