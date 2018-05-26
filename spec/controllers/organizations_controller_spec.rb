require 'spec_helper'

describe OrganizationsController do
  describe '#show' do
    let(:organization) { Fabricate(:organization) }
    let(:member) { Fabricate(:member, organization: organization) }

    it 'links to new_transfer_path' do
      login(member.user)

      get 'show', id: organization.id
      expect(response.body).to include(
        "<a href=\"/transfers/new?destination_account_id=#{organization.account.id}&amp;id=#{organization.id}\">"
      )
    end
  end
end
