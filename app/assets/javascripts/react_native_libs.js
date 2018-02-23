window.TimeOverflowRegisterExpoDeviceToken = function (token) {
  $.post('/device_tokens', { token: token });
}
