require 'spec_helper'

RSpec.describe PushNotifications::Broadcast do
  describe '#send_notifications' do
    let(:user) { Fabricate(:user) }
    let(:device_token) { Fabricate(:device_token, user: user) }
    let(:post) { Fabricate(:post) }
    let(:event_created) { Fabricate(:event, post: post, action: :created) }
    let(:push_notification) do
      Fabricate(
        :push_notification,
        event: event_created,
        device_token: device_token,
        title: 'Hola'
      )
    end
    let(:push_notifications) { PushNotification.all }
    let(:notification) do
      {
        to: push_notification.to,
        title: push_notification.title,
        body: 'WAT!?'
      }
    end
    let(:uri) { URI('https://exp.host/--/api/v2/push/send') }

    it 'calls Expo HTTP client to send notifications' do
      expect(Net::HTTP).to receive(:post_form).with(uri, [notification])

      described_class.new(push_notifications: push_notifications).send
    end

    it 'flags the push_notification as processed' do
      allow(Net::HTTP).to receive(:post_form).with(uri, [notification])

      described_class.new(push_notifications: push_notifications).send

      expect(push_notification.reload.processed_at).to_not be_nil
    end
  end
end
