currentUser = window.$USER

navigator.id.watch
  loggedInUser: currentUser
  onlogin: (assertion) ->
    $.ajax
      type: 'POST'
      url: '/login'
      data: {assertion}
      success: (res, status, xhr) ->
        window.location.reload()
        console.log 'persona authentication succesful'
      error: (xhr, status, err) ->
        navigator.id.logout()
        console.log "Login failure: #{err}"
  onlogout: ->
    $.ajax
      type: 'POST'
      url: '/logout'
      success: (res, status, xhr) ->
        window.location.reload()
        console.log 'logout from persona succesful'
      error: (xhr, status, err) ->
        console.log "Logout failure: #{err}"


jQuery ->
  jQuery('body').on "click", "#signin", -> navigator.id.request()
  jQuery('body').on "click", "#signout", -> navigator.id.logout()
