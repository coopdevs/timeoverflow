RSpec.describe Persister::TransferPersister do
  let(:source_account) { Fabricate(:account) }
  let(:destination_account) { Fabricate(:account) }
  let(:organization) { Fabricate(:organization) }
  let(:post) { Fabricate(:post, organization: organization) }
  let(:transfer) do
    Fabricate.build(
      :transfer,
      post: post,
      source: source_account,
      destination: destination_account
    )
  end
  let(:persister) { ::Persister::TransferPersister.new(transfer) }

  describe '#save' do
    before { persister.save }

    it 'saves the transfer' do
      expect(transfer).to be_persisted
    end

    # TODO: write better expectation
    it 'creates an event' do
      expect(Event.where(transfer_id: transfer.id).first.action).to eq('created')
    end
  end

  describe '#save with an idempotency key' do
    def build_transfer(key)
      Fabricate.build(:transfer, source: source_account, destination: destination_account, idempotency_key: key)
    end

    it 'does not create a duplicated transfer when the same form is submitted twice' do
      first = described_class.new(build_transfer('form-1')).save

      expect {
        expect(described_class.new(build_transfer('form-1')).save).to eq(first)
      }.not_to change { [Transfer.count, Movement.count, Event.count] }
    end

    it 'does not change the balances on the second submission' do
      described_class.new(build_transfer('form-1')).save

      expect {
        described_class.new(build_transfer('form-1')).save
      }.not_to change { source_account.reload.balance }
    end

    it 'creates different transfers for different keys' do
      described_class.new(build_transfer('form-1')).save

      expect {
        described_class.new(build_transfer('form-2')).save
      }.to change(Transfer, :count).by(1)
    end

    it 'creates every transfer when no key is given' do
      described_class.new(build_transfer(nil)).save

      expect {
        described_class.new(build_transfer(nil)).save
      }.to change(Transfer, :count).by(1)
    end
  end

  describe '#update' do
    before { persister.update(amount: 666) }

    it 'updates the resource attributes' do
      expect(transfer.amount).to eq(666)
    end

    # TODO: write better expectation
    it 'creates an event' do
      expect(Event.where(transfer_id: transfer.id).first.action).to eq('updated')
    end
  end
end
