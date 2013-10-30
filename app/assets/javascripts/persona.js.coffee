$(document).on "click", ".persona-login-button", (e) ->
  e.preventDefault()

  navigator.id.get (assertion) ->
    return unless assertion
    $.ajax
      url: '/sessions'
      type: "POST"
      headers:
        'X-Transaction': 'POST Example',
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
      cache: false
      data: {assertion}
      success: -> window.location.href = '/'
