@APP = angular.module("APP", ["http-auth-interceptor", "ui.directives", "ngResource"])

Function::property = (prop, desc) ->
  Object.defineProperty @prototype, prop, desc

Array::detect = (f) ->
  (return x if f x) for x in @
  undefined

Array::find = (id) ->
  (return x if x.id is id) for x in @
  undefined


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

