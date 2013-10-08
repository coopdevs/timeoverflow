currentUser = $PERSONA

navigator.id.watch
  loggedInUser: currentUser
  onlogin: (assertion) ->
    alert(assertion, "login")
    $.ajax
      type: 'POST'
      url: '/login'
      data: {assertion}
      success: (res, status, xhr) ->
        alert [res, status, xhr].join("\n"),  "login - success"
        window.location.reload()
      error: (xhr, status, err) ->
        alert [xhr, status, err].join("\n"),  "login - error"
        # console.log "navigator.id.logout()"
        navigator.id.logout()
        console.log "Login failure: #{err}"
  onlogout: ->
    alert("logout", "logout")
    $.ajax
      type: 'POST'
      url: '/logout'
      success: (res, status, xhr) ->
        alert [res, status, xhr].join("\n"),  "login - success"
        window.location.reload()
      error: (xhr, status, err) ->
        alert [xhr, status, err].join("\n"),  "login - error"
        console.log "Logout failure: #{err}"


$(document).on "click", "#signin", -> navigator.id.request()
$(document).on "click", "#signout", -> navigator.id.logout()

