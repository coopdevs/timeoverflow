require 'spec_helper'

RSpec.describe PushNotification do
  let!(:event) { Fabricate.build(:event) }
  let!(:device_token) { Fabricate.build(:device_token, token: 'token') }
  let!(:push_notification) { described_class.new(device_token: device_token) }

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:event) }
    it { is_expected.to validate_presence_of(:device_token) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
  end

  describe 'Not blank validations' do
    let(:valid_push_notification) {
      PushNotification.new(
        event: event,
        device_token: device_token,
        title: "A title",
        body: "A body"
      )
    }

    it 'validates non blank fields' do
      expect(valid_push_notification).to be_valid

      valid_push_notification.tap do |with_blank_title|
        with_blank_title.title = ''
        expect(with_blank_title).to_not be_valid
      end

      valid_push_notification.tap do |with_blank_body|
        with_blank_body.body = ''
        expect(with_blank_body).to_not be_valid
      end
    end
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:event).with_foreign_key('event_id') }
    it { is_expected.to belong_to(:device_token).with_foreign_key('device_token_id') }

    it { is_expected.to have_db_column(:event_id) }
    it { is_expected.to have_db_column(:device_token_id) }
  end

  describe "#token" do
    it 'returns the associated DeviceToken\'s token' do
      expect(push_notification.token).to eq('token')
    end
  end
end
