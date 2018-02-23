module PushNotifications
  class PostBroadcasterService
    def initialize(post)
      @post = post
    end

    def broadcast
      notification = PostNotification.new

      @post.organization.users.each do |user|
        ExpoAdaptorService.new(notification, user).send
      end
    end
  end
end
