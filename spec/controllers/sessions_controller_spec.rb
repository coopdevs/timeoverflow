require 'spec_helper'

RSpec.describe SessionsController do
  let(:user) do
    Fabricate(:user, password: 'papapa22', password_confirmation: 'papapa22')
  end

  describe '#create' do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
    end

    it 'does not show a notice flash message' do
      post :create, params: { user: {
        email: user.email,
        password: user.password
      } }
      expect(flash[:notice]).to be_nil
    end
  end

  describe '#destroy' do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      post :create, params: { user: {
        email: user.email,
        password: user.password
      } }
    end

    it 'does not show a notice flash message' do
      delete :destroy
      expect(flash[:notice]).to be_nil
    end
  end
end
