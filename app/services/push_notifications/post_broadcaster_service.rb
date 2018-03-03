module PushNotifications
  class UsersBroadcasterService
    def initialize(users)
      @users = users
    end

    def broadcast
      notification = PostNotification.new

      users.each do |user|
        ExpoSenderService.new(notification, user).run
      end
    end

    private

    attr_reader :users
  end
end
