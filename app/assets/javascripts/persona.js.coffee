$(document).on "click", ".persona-login-button", (e) ->
  e.preventDefault()

  navigator.id.get (assertion) ->
    return unless assertion
    $.ajax
      url: '/users/sign_in'
      type: "POST"
      dataType: "json"
      cache: false
      data:
        "assertion": assertion
      success: (data, status) -> window.location.href = '/'
