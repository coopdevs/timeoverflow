module PushNotifications
  class EventNotifierFactory
    def initialize(event:)
      @event = event
    end

    def build
      return EventNotifier::Post.new(event: event) if event.post_id

      raise 'The resource associated to the Event is not supported'
    end

    private

    attr_accessor :event
  end
end
