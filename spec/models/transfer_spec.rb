require 'spec_helper'

describe Transfer do
  pending "add some examples to (or delete) #{__FILE__}"

  let(:first_account) { Account.create! }
  let(:second_account) { Account.create! }

  describe 'effects on accounts' do
    it 'updates the balance of the source account' do
      expect {
        Transfer.create(amount: 5, destination: second_account, source: first_account)
      }.to change {
        first_account.balance.to_i
      }.by -5
    end
    it 'updates the balance of the destination account' do
      expect {
        Transfer.create(amount: 5, destination: second_account, source: first_account)
      }.to change {
        second_account.balance.to_i
      }.by 5
    end
  end
end

