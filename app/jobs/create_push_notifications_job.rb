class CreatePushNotificationsJob < ActiveJob::Base
  queue_as :default

  def perform(event_id:)
    event = ::Event.find_by_id(event_id)

    raise 'A valid Event must be provided' unless event

    ::PushNotifications::Creator.new(event: event).create!
  end
end
