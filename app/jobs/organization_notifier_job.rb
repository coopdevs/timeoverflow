# A weekly digest email.
#
# Strategy: go throught all organizations and take latest active posts from last week
# posted by active members. Send an email to all active and online members
# with the email notifications enabled with those posts.

# Schedule defined in config/schedule.yml file.

class OrganizationNotifierJob < ActiveJob::Base
  queue_as :cron

  def perform
    Organization.all.find_each do |org|
      posts = org.posts.active.of_active_members.from_last_week
      if posts.present?
        OrganizationNotifier.recent_posts(posts).deliver_now
      end
    end
  end
end
