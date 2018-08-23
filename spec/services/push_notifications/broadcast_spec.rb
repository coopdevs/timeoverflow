require 'spec_helper'

RSpec.describe PushNotifications::Broadcast do
  describe '#send_notifications' do
    let(:user) { Fabricate(:user) }
    let(:device_token) { Fabricate(:device_token, user: user) }
    let(:post) { Fabricate(:post) }
    let(:event_created) { Fabricate(:event, post: post, action: :created) }
    let(:push_notifications) { PushNotification.all }
    let(:notification) do
      {
        to: push_notification.to,
        title: push_notification.title,
        body: 'WAT!?'
      }
    end
    let(:uri) { URI('https://exp.host/--/api/v2/push/send') }
    let(:client) { Net::HTTP.new(uri.host, uri.port) }
    let(:headers) { { "Content-Type" => "application/json" } }

    context 'when there are push notifications to send' do
      let(:push_notification) do
        Fabricate(
          :push_notification,
          event: event_created,
          device_token: device_token,
          title: 'Hola'
        )
      end

      context 'when the HTTP response is OK' do
        let(:http_response) { Net::HTTPOK.new(1.0, 200, "OK") }

        it 'calls Expo API to send notifications' do
          allow(Net::HTTP).to receive(:new).with(uri.host, uri.port).and_return(client)
          expect(client).to receive(:post).with(uri.request_uri, [notification].to_json, headers).and_return(http_response)

          described_class.new(push_notifications: push_notifications).send_notifications
        end

        it 'flags the push_notification as processed' do
          allow(Net::HTTP).to receive(:new).with(uri.host, uri.port).and_return(client)
          allow(client).to receive(:post).with(uri.request_uri, [notification].to_json, headers).and_return(http_response)

          described_class.new(push_notifications: push_notifications).send_notifications

          expect(push_notification.reload.processed_at).to_not be_nil
        end

        context 'when the HTTP response is not OK' do
          let(:http_response) { Net::HTTPNotFound.new(1.0, 400, "Not Found") }

          it 'raises an error' do
            allow(Net::HTTP).to receive(:new).with(uri.host, uri.port).and_return(client)
            allow(client).to receive(:post).with(uri.request_uri, [notification].to_json, headers).and_return(http_response)
            allow(http_response).to receive(:body).and_return("Everything is broken!")

            expect {
              described_class.new(push_notifications: push_notifications).send_notifications
            }.to raise_error(::PushNotifications::Broadcast::PostError)
          end
        end
      end
    end

    context 'when there are no push notifications to send' do
      it 'calls Expo API to send notifications' do
        expect(Net::HTTP).to_not receive(:new).with(uri.host, uri.port)

        described_class.new(push_notifications: push_notifications).send_notifications
      end
    end
  end
end
