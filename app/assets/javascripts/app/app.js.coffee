@APP = angular.module("APP", ["http-auth-interceptor", "ngResource", "$strap.directives", "ui"])

Function::property = (prop, desc) ->
  Object.defineProperty @prototype, prop, desc


@APP.value 'ui.config',
  jq:
    datepicker:
      dateFormat: jQuery.datepicker.W3C
  # tinymce:
  #   # // General options
  #   mode: "textareas"
  #   theme: "advanced"
  #   # // Theme options
  #   theme_advanced_buttons1: "bold,italic,underline,sub,sup,forecolor,fontsizeselect"
  #   theme_advanced_buttons2: "justifyleft,justifycenter,justifyright,justifyfull,|,bullist,numlist,|,outdent,indent"
  #   theme_advanced_buttons3: ""

