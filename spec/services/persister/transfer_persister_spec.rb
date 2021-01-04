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

  describe '#update_attributes' do
    before { persister.update_attributes(amount: 666) }

    it 'updates the resource attributes' do
      expect(transfer.amount).to eq(666)
    end

    # TODO: write better expectation
    it 'creates an event' do
      expect(Event.where(transfer_id: transfer.id).first.action).to eq('updated')
    end
  end
end
