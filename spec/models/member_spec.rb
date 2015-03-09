require 'spec_helper'

describe Member do
  subject { Fabricate(:member) }

  it { should belong_to(:user) }
  it { should belong_to(:organization) }
  it { should have_one(:account) }
  it { should delegate_method(:balance).to(:account).with_prefix }
  it { should delegate_method(:gender).to(:user).with_prefix }
  it { should delegate_method(:date_of_birth).to(:user).with_prefix }

  it { should validate_presence_of(:organization_id) }
  it { should validate_presence_of(:member_uid) }

  describe "#offers" do
    let(:member) { Fabricate(:member) }
    let(:member_offer) { Fabricate(
      :offer,
      user: member.user,
      organization: member.organization)
    }

    it "should be a list of Offers matching user and organization" do
      another_member_offer = Fabricate(:offer)
      another_organization_offer = Fabricate(
        :offer,
        user: member.user,
        organization: Fabricate(:organization)
      )

      expect(member.offers).to include(member_offer)
      expect(member.offers).to_not include(another_member_offer)
      expect(member.offers).to_not include(another_organization_offer)
    end
  end

  context "callbacks" do
    context "#after_create" do
      let(:member) { Fabricate(:member) }

      it "should have an account" do
        expect(member.account).to_not be_nil
      end
    end

    context "#after_destroy" do
      let!(:member) { Fabricate(:member) }

      it "destroy user if it was last membership" do
        expect { member.destroy }.to change(User, :count).by(-1)
      end

      it "do not destroy user if it has more memberships" do
        second_member = Fabricate(:member, user: member.user)

        expect { second_member.destroy }.not_to change(User, :count)
      end
    end
  end
end
