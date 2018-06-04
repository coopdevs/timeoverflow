require 'spec_helper'

RSpec.describe PushNotifications::Broadcast do
  describe '#send' do
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
    let(:client) { instance_double(Exponent::Push::Client) }
    let(:notification) do
      {
        to: push_notification.to,
        title: push_notification.title
      }
    end

    it 'calls Expo HTTP client to send notifications' do
      expect(Exponent::Push::Client).to receive(:new).and_return(client)
      expect(client).to receive(:publish).with([notification])

      described_class.new(push_notifications: [push_notification]).send
    end
  end
end
