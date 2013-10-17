$(document).on "click", ".persona-login-button", (e) ->
  e.preventDefault()

  navigator.id.get (assertion) ->
    return unless assertion
    $.ajax
      url: '/users/sign_in'
      type: "POST"
      cache: false
      data: {assertion}
      success: -> window.location.href = '/'
