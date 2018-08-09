module Persister
  class PostPersister
    attr_accessor :post

    def initialize(post)
      @post = post
    end

    def save
      ::ActiveRecord::Base.transaction do
        post.save!
        create_save_event!
        enqueue_push_notification_job!
        post
      end
    rescue ActiveRecord::RecordInvalid => _exception
      false
    end

    def update_attributes(params)
      ::ActiveRecord::Base.transaction do
        post.update_attributes!(params)
        create_update_event!
        enqueue_push_notification_job!
        post
      end
    rescue ActiveRecord::RecordInvalid => _exception
      false
    end

    private

    attr_accessor :event

    def create_save_event!
      @event = ::Event.create! action: :created, post: post
    end

    def create_update_event!
      @event = ::Event.create! action: :updated, post: post
    end

    def enqueue_push_notification_job!
      CreatePushNotificationsJob.perform_later(event_id: event.id)
    end
  end
end
