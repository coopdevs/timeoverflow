RSpec.describe MembershipWarningJob, type: :job do
  let!(:org) { Fabricate(:organization) }
  let!(:user) { Fabricate(:user) }
  let!(:member) { Fabricate(:member, organization: org, user: user) }
  let!(:user_with_no_memberships) { Fabricate(:user) }
  let!(:user_with_no_memberships2) { Fabricate(:user, created_at: 15.days.ago) }

  describe '#perform' do
    it "should send emails in user's locale" do
      expect {
        MembershipWarningJob.perform_now
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
