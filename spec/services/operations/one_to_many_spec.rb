RSpec.describe Operations::Transfers::OneToMany do
  let(:source_account) { Fabricate(:account) }
  let(:destination_accounts) { 5.times.map { Fabricate(:account) } }

  let(:operation) do
    Operations::Transfers::OneToMany.new(
      from: [source_account.id],
      to: destination_accounts.map(&:id),
      transfer_params: { amount: 3600, reason: 'why not' }
    )
  end

  describe '#perform' do
    it 'creates multiple transfers' do
      expect { operation.perform }.to change { Transfer.count }.by(5)
    end

    it 'creates many movements from source account' do
      expect { operation.perform }.to change { Movement.where(account_id: source_account.id).count }.by(5)
    end

    it 'creates one movement towards each target account' do
      expect { operation.perform }.to change { Movement.where(account_id: destination_accounts.map(&:id)).map(&:account_id).uniq.count }.by(5)
    end
  end

  describe 'submitting the same multi transfer form twice' do
    let(:operation_with_key) do
      lambda do
        Operations::Transfers::OneToMany.new(
          from: [source_account.id],
          to: destination_accounts.map(&:id),
          transfer_params: { amount: 3600, reason: 'why not', idempotency_key: 'form-1' }.with_indifferent_access
        )
      end
    end

    it 'creates the transfers only once' do
      operation_with_key.call.perform

      expect { operation_with_key.call.perform }.not_to change { [Transfer.count, Movement.count] }
    end

    it 'gives each transfer of the form its own key' do
      operation_with_key.call.perform

      expect(Transfer.pluck(:idempotency_key).uniq.size).to eq(5)
    end
  end
end
