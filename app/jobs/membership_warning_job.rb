class MembershipWarningJob < ActiveJob::Base
  queue_as :cron

  def perform
    User.without_memberships.find_each do |user|
      if user.created_at.to_date == 15.days.ago.to_date && user.no_membership_warning?
        OrganizationNotifier.no_membership_warning(user).deliver_now
      end
    end
  end
end
