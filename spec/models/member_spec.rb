require 'spec_helper'

describe Member do
  context "callbacks" do
    context "after_destroy" do
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
