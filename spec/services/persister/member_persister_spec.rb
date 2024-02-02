RSpec.describe Persister::MemberPersister do
  let(:organization) { Fabricate(:organization) }
  let(:user) { Fabricate(:user) }
  let(:member) { Fabricate.build(:member, user: user, organization: organization) }
  let(:persister) { ::Persister::MemberPersister.new(member) }

  describe "#save" do
    before { persister.save }

    it "saves the member" do
      expect(member).to be_persisted
    end

    # TODO: write better expectation
    it "creates an event" do
      expect(Event.where(member_id: member.id).first.action).to eq("created")
    end
  end

  describe "#update" do
    before { persister.update(member_uid: 666) }

    it "updates the resource attributes" do
      expect(member.member_uid).to eq(666)
    end

    # TODO: write better expectation
    it "creates an event" do
      expect(Event.where(member_id: member.id).first.action).to eq("updated")
    end
  end
end
