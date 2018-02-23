require 'net/http'

module PushNotifications
  class ExpoAdaptorService
    def initialize(notification, user)
      @notification = notification
      @user = user
    end

    def send
      @user.device_tokens.each do |device_token|
        # https://docs.expo.io/versions/latest/guides/push-notifications.html
        uri = URI('https://exp.host/--/api/v2/push/send')
        Net::HTTP.post_form(uri, post_data(device_token.token))
      end
    end

    private

    def post_data(token)
      {
        "to" => token,
        "title" => @notification.title,
        "body" => @notification.body
      }
    end
  end
end
