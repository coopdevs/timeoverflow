RSpec.describe TransferFactory do
  describe '#build_transfer (cross‑bank transfer)' do
    let(:source_org)  { Fabricate(:organization) }
    let(:dest_org)    { Fabricate(:organization) }
    let(:current_user) { Fabricate(:user) }
    let!(:source_member) { Fabricate(:member, user: current_user, organization: source_org) }
    let(:offer) { Fabricate(:offer, organization: dest_org) }


    let!(:alliance) do
      OrganizationAlliance.create!(
        source_organization: source_org,
        target_organization: dest_org,
        status: "accepted"
      )
    end

    subject(:transfer) do
      described_class.new(source_org, current_user, offer.id, nil, true).build_transfer
    end

    it 'marks the transfer as cross‑bank' do
      expect(transfer.is_cross_bank).to be true
    end

    it 'sets the source to the current user account' do
      expect(transfer.source_id).to eq(source_member.account.id)
    end

    it 'sets the destination to the destination organization account' do
      expect(transfer.destination_id).to eq(dest_org.account.id)
    end

    it 'stores metadata required to rebuild the six‑movement chain' do
      expect(transfer.meta).to eq(
        source_organization_id: source_org.id,
        destination_organization_id: dest_org.id,
        final_destination_user_id: offer.user.id
      )
    end

    it 'associates the offer as the transfer post' do
      expect(transfer.post).to eq(offer)
    end
  end
end
