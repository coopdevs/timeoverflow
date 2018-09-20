module PushNotifications
  class Broadcast
    class PostError < ::StandardError; end

    def initialize(push_notifications:)
      @push_notifications = push_notifications
    end

    # https://docs.expo.io/versions/latest/guides/push-notifications.html
    def send_notifications
      return unless push_notifications.any?

      response = client.post(
        uri.request_uri,
        notifications.to_json,
        headers
      )

      unless response.is_a? Net::HTTPOK
        raise PostError, "HTTP response: #{response.code}, #{response.body}"
      end

      now = Time.now.utc
      push_notifications.update_all(processed_at: now, updated_at: now)
    end

    private

    attr_reader :push_notifications

    def notifications
      push_notifications.map do |push_notification|
        {
          to: push_notification.token,
          title: push_notification.title,
          body: push_notification.body,
          data: push_notification.data
        }
      end
    end

    def client
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      https
    end

    def uri
      URI('https://exp.host/--/api/v2/push/send')
    end

    def headers
      {
        "Content-Type" => "application/json"
      }
    end
  end
end
