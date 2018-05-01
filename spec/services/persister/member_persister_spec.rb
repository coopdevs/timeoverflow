require 'spec_helper'

describe Persister::MemberPersister do
  let(:organization) { Fabricate(:organization) }
  let(:user) { Fabricate(:user) }

  describe '#save' do
    it 'saves the member' do
      member = Member.new(user: user, organization: organization)

      persister = ::Persister::MemberPersister.new(member)
      persister.save

      expect(member).to be_persisted
    end
  end
end
