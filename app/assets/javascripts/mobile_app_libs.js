// Used by the mobile app to register the device token
// https://github.com/coopdevs/timeoverflow-mobile-app
window.TimeOverflowRegisterExpoDeviceToken = function (token) {
  $.post('/device_tokens', { token: token });
}
