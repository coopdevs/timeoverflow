RSpec.describe TransferFactory do
  let(:transfer_factory) do
    described_class.new(
      organization,
      current_user,
      offer_id,
      destination_account_id
    )
  end

  let(:organization) { Fabricate(:organization) }
  let(:current_user) { Fabricate(:user) }
  let(:organization_offer) { Fabricate(:offer, organization: organization) }
  let(:destination_account_id) { nil }

  describe '#offer' do
    subject { transfer_factory.offer }

    context 'when the offer exists' do
      let(:offer_id) { organization_offer.id }
      it { is_expected.to eq(organization_offer) }
    end

    context 'when the offer does not exist' do
      let(:offer_id) { -1 }
      it { is_expected.to be_nil }
    end
  end

  describe '#build_transfer' do
    subject(:transfer) { transfer_factory.build_transfer }

    let(:offer_id) { organization_offer.id }
    let(:destination_account_id) { destination_account.id }

    context 'when the destination account belongs to an organization' do
      let(:organization) { Fabricate(:organization) }
      let(:destination_account) { organization.account }

      before do
        Fabricate(:member, user: current_user, organization: organization)
      end

      it 'does not assign the offer as the transfer post' do
        expect(transfer.post).to be_nil
      end
    end

    context 'when the destination account belongs to a member' do
      let(:member) do
        Fabricate(:member, organization: organization, user: current_user)
      end
      let(:destination_account) { member.account }

      it { is_expected.to be_a(Transfer) }

      it 'assigns the offer as the transfer post' do
        expect(transfer.post).to eq(organization_offer)
      end

      context 'and the user does not belong to the organization' do
        let(:another_organization) { Fabricate(:organization) }
        let(:member) do
          Fabricate(:member, organization: another_organization, user: current_user)
        end
        let(:destination_account) { member.account }

        it 'raises an error' do
          expect { transfer_factory.build_transfer }
            .to raise_error(NoMethodError, /undefined method `account' for nil:NilClass/)
        end
      end
    end
  end

  context '#transfer_sources' do
    subject { transfer_factory.transfer_sources }

    let(:offer_id) { organization_offer.id }

    let!(:active_member) do
      Fabricate(:member, organization: organization, active: true)
    end
    let!(:inactive_member) do
      Fabricate(:member, organization: organization, active: false)
    end

    context 'when the user is admin of the organization' do
      before do
        allow(current_user).to receive(:manages?).with(organization) { true }
      end

      it { is_expected.to eq([organization.account, active_member.account]) }
    end

    context 'when the user is not admin of the organization' do
      before do
        allow(current_user).to receive(:manages?).with(organization) { false }
      end

      it { is_expected.to eq([]) }
    end
  end
end
