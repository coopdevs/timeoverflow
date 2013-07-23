currentUser = $PERSONA

navigator.id.watch
  loggedInUser: currentUser
  onlogin: (assertion) ->
    $.ajax
      type: 'POST'
      url: '/login'
      data: {assertion}
      success: (res, status, xhr) -> window.location.reload()
      error: (xhr, status, err) ->
        # console.log "navigator.id.logout()"
        navigator.id.logout()
        console.log "Login failure: #{err}"
  onlogout: ->
    $.ajax
      type: 'POST'
      url: '/logout'
      success: (res, status, xhr) -> window.location.reload()
      error: (xhr, status, err) -> console.log "Logout failure: #{err}"


$ ->
  $('body').on "click", "#signin", -> navigator.id.request()
  $('body').on "click", "#signout", -> navigator.id.logout()
