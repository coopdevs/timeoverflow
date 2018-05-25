module PushNotifications
  module EventNotifier
    class Post
      def initialize(event:)
        @event = event
        @post = event.post
      end

      # Conditions for Post:
      #
      # We need to notify all the users that:
      #  - are members of the Post's organization
      #  - have a DeviceToken associated
      #
      # @return [<DeviceToken>]
      def device_tokens
        organization = post.organization
        DeviceToken.where(user_id: organization.user_ids)
      end

      private

      attr_accessor :event, :post
    end
  end
end
