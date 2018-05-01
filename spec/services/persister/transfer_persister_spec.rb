require 'spec_helper'

describe Persister::TransferPersister do
  let(:source_account) { Fabricate(:account) }
  let(:destination_account) { Fabricate(:account) }
  let(:organization) { Fabricate(:organization) }
  let(:post) { Fabricate(:post, organization: organization) }

  describe '#save' do
    it 'saves the transfer' do
      transfer = Transfer.new(post: post, source: source_account, destination: destination_account)

      persister = ::Persister::TransferPersister.new(transfer)
      persister.save

      expect(transfer).to be_persisted
    end
  end
end
