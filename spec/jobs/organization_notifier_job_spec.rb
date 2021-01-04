RSpec.describe OrganizationNotifierJob, type: :job do
  let!(:org) { Fabricate(:organization) }
  let!(:user) { Fabricate(:user, locale: :en, sign_in_count: 1) }
  let!(:member) { Fabricate(:member, organization: org, user: user) }
  let!(:user2) { Fabricate(:user, locale: :ca, sign_in_count: 2) }
  let!(:member2) { Fabricate(:member, organization: org, user: user2) }
  let!(:offer) { Fabricate(:offer, organization: org, user: user) }
  let!(:inquiry) { Fabricate(:inquiry, organization: org, user: user2) }

  describe '#perform' do
    it "should send emails in user's locale" do
      expect {
        OrganizationNotifierJob.perform_now
      }.to change { ActionMailer::Base.deliveries.count }.by(2)
    end
  end
end
