require 'spec_helper'

RSpec.describe PushNotification do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:event) }
    it { is_expected.to validate_presence_of(:device_token) }
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:event).with_foreign_key('event_id') }
    it { is_expected.to belong_to(:device_token).with_foreign_key('device_token_id') }

    it { is_expected.to have_db_column(:event_id) }
    it { is_expected.to have_db_column(:device_token_id) }
  end

  describe "#to" do
    let(:device_token) { Fabricate.build(:device_token, token: 'token') }
    let(:push_notification) { described_class.new(device_token: device_token) }

    it 'returns the associated DeviceToken\'s token' do
      expect(push_notification.to).to eq('token')
    end
  end
end
