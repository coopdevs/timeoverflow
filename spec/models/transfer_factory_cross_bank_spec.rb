RSpec.describe TransferFactory do
  describe '#build_transfer (cross‑bank transfer)' do
    let(:source_org) { Fabricate(:organization) }
    let(:dest_org) { Fabricate(:organization) }
    let(:current_user) { Fabricate(:user) }
    let!(:source_member) { Fabricate(:member, user: current_user, organization: source_org) }
    let(:dest_user) { Fabricate(:user) }
    let!(:dest_member) { Fabricate(:member, user: dest_user, organization: dest_org) }
    let(:offer) { Fabricate(:offer, user: dest_user, organization: dest_org) }
    let(:destination_account_id) { nil }

    let!(:alliance) do
      OrganizationAlliance.create!(
        source_organization: source_org,
        target_organization: dest_org,
        status: "accepted"
      )
    end

    let(:transfer_factory) do
      factory = described_class.new(
        source_org,
        current_user,
        offer.id,
        destination_account_id
      )
      allow(factory).to receive(:cross_bank).and_return(true)
      factory
    end

    before do
      allow(transfer_factory).to receive(:destination_account).and_return(dest_org.account)
      allow_any_instance_of(Transfer).to receive(:is_cross_bank=)
    end

    describe '#build_transfer' do
      subject(:transfer) { transfer_factory.build_transfer }

      it { is_expected.to be_a(Transfer) }

      it 'sets the source to the current user account' do
        expect(transfer.source_id).to eq(source_member.account.id)
      end

      it 'sets the destination to the destination organization account' do
        expect(transfer.destination_id).to eq(dest_org.account.id)
      end

      it 'associates the offer as the transfer post' do
        expect(transfer.post).to eq(offer)
      end
    end
  end
end
