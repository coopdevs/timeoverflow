module PushNotifications
  class Creator
    # Given an Event it will create as many PushNotification resources
    # necessary as the resource associated to the Event will require.
    #
    # @param [Hash] event: <Event>
    def initialize(event:)
      @event = event
    end

    def create!
      event_notifier = EventNotifierFactory.new(event: event).build
      event_notifier.device_tokens.each do |device_token|
        PushNotification.create!(
          event: event,
          device_token: device_token,
          title: title
        )
      end
    end

    private

    attr_accessor :event

    # TODO: For now we only create push notifications for Post
    #
    def title
      'A new post has been created.'
    end
  end
end
