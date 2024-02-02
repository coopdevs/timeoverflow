RSpec.describe OrganizationNotifier do
  let(:test_organization) { Fabricate(:organization) }
  let!(:offer) { Fabricate(:offer, organization: test_organization) }
  let!(:inquiry) { Fabricate(:inquiry, organization: test_organization) }
  let(:user) { Fabricate(:user, email: "user@example.com", locale: :en) }
  let(:member) { Fabricate(:member, organization: test_organization, user: user) }

  describe "send an email" do
    it "should send an email" do
      expect do
        OrganizationNotifier.recent_posts(test_organization.posts, :en, [user]).deliver_now
      end.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  describe "recent posts" do
    let(:mail) { OrganizationNotifier.recent_posts(test_organization.posts, :en, [user]) }

    it "receive email only active and online users" do
      expect(mail.bcc).to eql(["user@example.com"])
    end
    it "to should be null" do
      expect(mail.to).to be_nil
    end
    it "body contains organization name" do
      expect(mail.body.encoded).to match(test_organization.name)
    end
  end
end
