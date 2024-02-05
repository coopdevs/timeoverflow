RSpec.describe TransfersHelper do
  describe 'accounts_from_movements' do
    let(:organization) { Fabricate(:organization) }
    let(:member) { Fabricate(:member, organization: organization) }
    let(:transfer) { Fabricate(:transfer, source: organization.account, destination: member.account) }

    it 'return accounts entries' do
      expect(helper.accounts_from_movements(transfer)).to eq([
        organization.to_s,
        member.display_name_with_uid
      ])
    end

    it 'return accounts entries with links' do
      expect(helper.accounts_from_movements(transfer, with_links: true)).to include(/<a href=.*<\/a>/)
    end
  end
end
