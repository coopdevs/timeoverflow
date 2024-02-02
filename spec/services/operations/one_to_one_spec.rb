RSpec.describe Operations::Transfers::OneToMany do
  let(:source_account) { Fabricate(:account) }
  let(:destination_account) { Fabricate(:account) }

  let(:operation) do
    Operations::Transfers::OneToOne.new(
      from: [source_account.id],
      to: [destination_account.id],
      transfer_params: { amount: 3600, reason: "why not" }
    )
  end

  describe "#perform" do
    it "creates multiple transfers" do
      expect { operation.perform }.to change { Transfer.count }.by(1)
    end

    it "creates one movement towards destination account" do
      expect { operation.perform }.to change {
                                        Movement.where(account_id: source_account.id).count
                                      }.by(1)
    end

    it "creates one movement from each source account" do
      expect { operation.perform }.to change {
                                        Movement.where(account_id: destination_account.id).count
                                      }.by(1)
    end
  end
end
