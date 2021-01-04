RSpec.describe SendPushNotificationsJob, type: :job do
  describe '#perform' do
    let(:user) { Fabricate(:user) }
    let(:device_token) { Fabricate(:device_token, user: user) }
    let(:post) { Fabricate(:post) }
    let(:event_created) { Fabricate(:event, post: post, action: :created) }
    let(:event_updated) { Fabricate(:event, post: post, action: :updated) }
    let(:push_notification) do
      Fabricate(
        :push_notification,
        event: event_created,
        device_token: device_token,
        title: 'A new Post hase been created.',
        body: 'A push notification body.'
      )
    end
    let(:processed_push_notification) do
      Fabricate(
        :push_notification,
        event: event_updated,
        device_token: device_token,
        title: 'A new Post hase been created.',
        body: 'A push notification body.',
        processed_at: Time.zone.now
      )
    end

    before do
      push_notification
      processed_push_notification
    end

    it 'calls Broadcast to send the notifications' do
      broadcast = instance_double(::PushNotifications::Broadcast)
      expect(::PushNotifications::Broadcast).to receive(:new)
        .with(push_notifications: [push_notification])
        .and_return(broadcast)
      expect(broadcast).to receive(:send_notifications)

      described_class.new.perform
    end
  end
end
