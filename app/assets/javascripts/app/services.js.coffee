@APP.factory "I18n", ->

  translations =
    ca:
      "userForm.nombre": "Nom"
      "userForm.organizacion": "Organització"
      "userForm.email": "Email"
      "userForm.admin": "És administrador"
      "userForm.superadmin": "És superadministrador"
      "userForm.fechaalta": "Data d'alta"
      "userForm.password": "Contrasenya"
      "userForm.rpassword": "Repetir contrasenya"
      "userForm.fechanacimiento": "Data de neixement"
      "userForm.ndocumento": "Número de document (DNI/Pasaport/...)"
      "userForm.telofono": "Telèfon principal"
      "userForm.telefonoalt": "Telèfon alternatiu"
      "userForm.servicios": "Serveis ofertats"
      "userForm.siguientepaso": "Pas següent"
      "userForm.guardar": "Desar"
      "userForm.cancelar": "Cancel·la"
      "userForm.nombre": "Nom"
      "userForm.nombre": "Nom"
    

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






