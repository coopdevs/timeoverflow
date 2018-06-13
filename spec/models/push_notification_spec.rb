require 'spec_helper'

RSpec.describe PushNotification do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:event) }
    it { is_expected.to validate_presence_of(:device_token) }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:event).with_foreign_key('event_id') }
    it { is_expected.to belong_to(:device_token).with_foreign_key('device_token_id') }

    it { is_expected.to have_db_column(:event_id) }
    it { is_expected.to have_db_column(:device_token_id) }
  end
end
