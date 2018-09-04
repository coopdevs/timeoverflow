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
        DeviceToken.where(user_id: user_ids)
      end

      private

      attr_accessor :event, :post

      # Returns an ActiveRecord relation with the ids of the users
      # that comply the following conditions:
      #
      # - they have an active membership
      # - their `push_notification` flag is set to true
      #
      # @return <User::ActiveRecord_AssociationRelation>
      def user_ids
        post
          .organization
          .users
          .select(:id)
          .where('members.active = true')
          .where('users.push_notifications = true')
      end
    end
  end
end
