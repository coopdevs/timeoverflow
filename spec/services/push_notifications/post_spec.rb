require 'spec_helper'

RSpec.describe PushNotifications::Creator::Post do
  let(:user) { Fabricate(:user) }
  let!(:device_token) { Fabricate(:device_token, user: user, token: 'aloha') }
  let(:organization) { Fabricate(:organization) }
  let(:post) { Fabricate(:post, organization: organization, user: user) }
  let(:event) { Fabricate.build(:event, post: post, action: :created) }
  let(:creator) { described_class.new(event: event) }

  before do
    organization.members.create(user: user)
  end

  describe '#create!' do
    it 'creates as many PushNotification resources as needed' do
      expect {
        creator.create!
      }.to change{PushNotification.count}.by(1)
    end
  end
end
