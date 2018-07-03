require 'spec_helper'

RSpec.describe OrganizationsController do
  let(:organization) { Fabricate(:organization) }
  let(:member) { Fabricate(:member, organization: organization) }
  let(:user) { member.user }

  describe '#show' do
    it 'links to new_transfer_path' do
      get 'show', id: organization.id
      expect(response.body).to include(
        "<a href=\"/transfers/new?destination_account_id=#{organization.account.id}&amp;id=#{organization.id}\">"
      )
    end
  end

  describe '#set_current' do
    before { login(user) }

    it 'stores the given organization as current organization in session' do
      post 'set_current', id: organization.id

      expect(session[:current_organization_id]).to eq(organization.id)
    end
  end
end
