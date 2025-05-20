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

  describe "#is_bank_to_bank_transfer?" do
    let(:organization1) { Fabricate(:organization) }
    let(:organization2) { Fabricate(:organization) }
    let(:user) { Fabricate(:user) }
    let(:member) { Fabricate(:member, organization: organization1, user: user) }

    context "when transfer is between two organizations" do
      let(:transfer) do
        transfer = Transfer.new(
          source: organization1.account,
          destination: organization2.account,
          amount: 60 # 1 hour
        )
        # Save the transfer to create the movements
        ::Persister::TransferPersister.new(transfer).save
        transfer
      end

      it "returns true" do
        expect(helper.is_bank_to_bank_transfer?(transfer)).to be true
      end
    end

    context "when transfer is from a user to an organization" do
      let(:transfer) do
        transfer = Transfer.new(
          source: member.account,
          destination: organization1.account,
          amount: 60
        )
        ::Persister::TransferPersister.new(transfer).save
        transfer
      end

      it "returns false" do
        expect(helper.is_bank_to_bank_transfer?(transfer)).to be false
      end
    end

    context "when transfer has a post associated" do
      let(:post) { Fabricate(:post, organization: organization1) }
      let(:transfer) do
        transfer = Transfer.new(
          source: organization1.account,
          destination: organization2.account,
          amount: 60,
          post: post # With associated post
        )
        ::Persister::TransferPersister.new(transfer).save
        transfer
      end

      it "returns false" do
        expect(helper.is_bank_to_bank_transfer?(transfer)).to be false
      end
    end

    context "when transfer is nil" do
      it "returns false" do
        expect(helper.is_bank_to_bank_transfer?(nil)).to be false
      end
    end
  end
end
