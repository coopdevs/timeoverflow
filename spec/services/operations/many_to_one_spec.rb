RSpec.describe Operations::Transfers::ManyToOne do
  let(:source_accounts) { 5.times.map { Fabricate(:account) } }
  let(:destination_account) { Fabricate(:account) }

  let(:operation) do
    Operations::Transfers::ManyToOne.new(
      from: source_accounts.map(&:id),
      to: [destination_account.id],
      transfer_params: { amount: 3600, reason: "why not" }
    )
  end

  describe "#perform" do
    it "creates multiple transfers" do
      expect { operation.perform }.to change { Transfer.count }.by(5)
    end

    it "creates many movements towards destination account" do
      expect { operation.perform }.to change {
                                        Movement.where(account_id: destination_account.id).count
                                      }.by(5)
    end

    it "creates one movement from each source account" do
      expect { operation.perform }.to change {
                                        Movement.where(account_id: source_accounts.map(&:id)).map(&:account_id).uniq.count
                                      }.by(5)
    end
  end
end
