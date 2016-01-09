require "spec_helper"

describe OrganizationNotifier do
  let (:test_organization) { Fabricate(:organization) }
  let! (:offer) { Fabricate(:offer, organization: test_organization) }
  let! (:inquiry) { Fabricate(:inquiry, organization: test_organization) }
  let (:user) do
    Fabricate(:user, sign_in_count: 2, email: "user@example.com")
  end
  let (:another_user) { Fabricate(:user, sign_in_count: 1) }
  let (:yet_another_user) { Fabricate(:user, sign_in_count: 0) }
  let! (:member) do
    Fabricate(:member,
              organization: test_organization,
              user: user,
              active: true)
  end
  let! (:another_member) do
    Fabricate(:member,
              organization: test_organization,
              user: another_user,
              active: false)
  end
  let! (:yet_another_member) do
    Fabricate(:member,
              organization: test_organization,
              user: yet_another_user,
              active: true)
  end

  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    OrganizationNotifier.recent_posts(test_organization.posts).deliver_now
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  describe "send an email" do
    it "should send an email" do
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end

  describe "recent posts" do
    let(:mail) { OrganizationNotifier.recent_posts(test_organization.posts) }

    it "receive email only active and online users" do
      expect(mail.bcc).to eql(["user@example.com"])
    end
    it "to should be null" do
      expect(mail.to).to be_nil
    end
    it "assigns @organization_name" do
      expect(mail.body.encoded).to match(test_organization.name)
    end
  end
end
