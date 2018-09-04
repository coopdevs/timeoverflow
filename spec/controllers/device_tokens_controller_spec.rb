require 'spec_helper'

RSpec.describe DeviceTokensController do
  let (:organization) { Fabricate(:organization) }
  let (:member) { Fabricate(:member, organization: organization) }

  describe 'POST #create' do
    context 'without login' do
      it 'responds with error' do
        expect do
          post :create
        end.to change(DeviceToken, :count).by(0)
      end
    end

    context 'with valid params' do
      it 'creates a new device_token' do
        login(member.user)

        expect do
          post :create, token: 'xxx'
        end.to change(DeviceToken, :count).by(1)
      end
    end

    context 'with invalid params' do
      it 'responds with error' do
        login(member.user)
        post :create
        expect(response.status).to eq(422)
      end
    end
  end
end
