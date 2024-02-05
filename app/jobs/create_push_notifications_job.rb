class CreatePushNotificationsJob < ActiveJob::Base
  queue_as :default

  def perform(event_id:)
    event = ::Event.find_by_id(event_id)

    raise 'A valid Event must be provided' unless event

    if event.post_id
      ::PushNotifications::Creator::Post.new(event: event).create!
    else
      raise "You need to define a PushNotifications::Creator class for this event type ##{event.id}"
    end
  end
end
