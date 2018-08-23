require 'net/http'

module PushNotifications
  class Broadcast
    def initialize(push_notifications:)
      @push_notifications = push_notifications
    end

    # https://docs.expo.io/versions/latest/guides/push-notifications.html
    def send
      return unless push_notifications.any?

      uri = URI('https://exp.host/--/api/v2/push/send')
      Net::HTTP.post_form(uri, notifications)

      push_notifications.update_all(processed_at: Time.now.utc)
    end

    private

    attr_reader :push_notifications

    def notifications
      push_notifications.map do |push_notification|
        {
          to: push_notification.to,
          title: push_notification.title,
          body: 'WAT!?'
        }
      end
    end
  end
end
