require 'spec_helper'

RSpec.describe ::PushNotifications::EventNotifier::Post do
  let(:user) { Fabricate.build(:user) }
  let(:organization) { Fabricate(:organization) }
  let(:post) { Fabricate(:post, organization: organization, user: user) }
  let(:event) { Fabricate.build(:event, post: post, action: :created) }

  describe '#users' do
    context 'when a user pertains to the Post\'s organization' do
      before { organization.members.create(user: user) }

      context 'and the user has a DeviceToken associated' do
        let!(:device_token) { Fabricate(:device_token, user: user, token: 'aloha') }

        it 'returns the device token associated with the user' do
          expect(described_class.new(event: event).device_tokens).to eq([device_token])
        end
      end

      context 'but the user has no DeviceToken associated' do
        it 'doesn\'t return the user' do
          expect(described_class.new(event: event).device_tokens).to eq([])
        end
      end
    end

    context 'when a user doesn\'t pertain to the Post\'s organization' do
      let(:other_user) { Fabricate(:user) }
      let!(:device_token) { Fabricate(:device_token, user: other_user, token: 'WAT') }

      it 'doesn\'t return the user' do
        expect(described_class.new(event: event).device_tokens).to_not include(device_token)
      end
    end
  end
end
