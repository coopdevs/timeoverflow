RSpec.describe PostsHelper do
  let(:organization) { Fabricate(:organization) }
  let(:member) { Fabricate(:member, organization: organization) }
  let(:offer) { Fabricate(:offer, user: member.user, organization: organization) }

  describe "#members_for_select" do
    before do
      allow(view).to receive(:current_organization) { organization }
    end

    it "returns organization active members with member_uid and name" do
      expect(helper.members_for_select(offer)).to match(/<option selected.*>#{member.member_uid} #{member.user}<\/option>/)
    end
  end
end
