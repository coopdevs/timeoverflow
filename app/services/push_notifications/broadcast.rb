module PushNotifications
  class Broadcast
    def initialize(push_notifications:)
      @push_notifications = push_notifications
    end

    def send
      return unless push_notifications.any?

      client = Exponent::Push::Client.new

      push_notifications.update_all(processed_at: Time.now.utc)
      client.publish(notifications)
    end

    private

    attr_reader :push_notifications

    def notifications
      push_notifications.map do |push_notification|
        {
          to: push_notification.to,
          title: push_notification.title
        }
      end
    end
  end
end
