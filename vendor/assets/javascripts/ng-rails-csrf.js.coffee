angular.module("ng-rails-csrf", []).config(
  ["$httpProvider", ($httpProvider) ->
    getToken = ->
      document.querySelector("meta[name=\"csrf-token\"]").getAttribute("content")

    updateToken = ->
      headers = $httpProvider.defaults.headers.common
      token = getToken()
      if token
        headers["X-CSRF-TOKEN"] = token
        headers["X-Requested-With"] = "XMLHttpRequest"
      return

    updateToken()
    $(document).bind "page:change", updateToken  if window["Turbolinks"]
  ]
)
