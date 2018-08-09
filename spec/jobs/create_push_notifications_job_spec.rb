require 'spec_helper'

RSpec.describe CreatePushNotificationsJob, type: :job do
  describe '#perform' do
    context 'with an Event that doesn\'t exist' do
      let(:event_id) { nil }

      it 'raises an error' do
        expect {
          described_class.new.perform(event_id: event_id)
        }.to raise_error 'A valid Event must be provided'
      end
    end

    context 'with an Event that does exist' do
      let(:post) { Fabricate(:post) }
      let(:event) { Fabricate(:event, post: post, action: :created) }
      let(:event_id) { event.id }

      it 'calls the PushNotification creator' do
        creator = instance_double(::PushNotifications::Creator)
        expect(::PushNotifications::Creator).to receive(:new)
          .with(event: event)
          .and_return(creator)
        expect(creator).to receive(:create!)

        described_class.new.perform(event_id: event_id)
      end
    end
  end
end
