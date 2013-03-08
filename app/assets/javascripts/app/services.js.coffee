@APP.factory "I18n", ->

  translations =
    ca:
      "Save changes": "Desar"
      "userForm.name": "Nom d'usuari"
    es:
      "Save changes": "Guardar"
      "userForm.name": "Nombre de usuario"

  currentLanguage: navigator.language || navigator.userLanguage

  setLanguage: (language) ->
    @currentLanguage = language

  t: (word) ->
    translations[@currentLanguage]?[word]




@APP.directive "translationContext", ->
  scope: true
  link: (scope, elem, attrs) ->
    scope.translationContext = attrs.translationContext




@APP.directive "translate", ["I18n", (I18n) ->
  scope: true
  link: (scope, elem, attrs) ->
    translationKey = attrs.translate
    orig = elem.html()

    scope.$on "locale:change", (ev, data) ->
      I18n.currentLocale = data.locale
      scope.setupTranslations()

    scope.$watch "$parent.translationContext", ->
      scope.setupTranslations()

    key = ->
      switch translationKey[0]
        when "."
          (scope.$parent.translationContext ? "") + translationKey
        else
          translationKey

    scope.setupTranslations = ->
      if (maybe = I18n.t(key()))?
        elem.html maybe
      else
        elem.html orig

    scope.setupTranslations()

]






