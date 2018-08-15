class OrganizationNotifierJob < ActiveJob::Base
  queue_as :cron

  def perform
    Organization.all.find_each do |org|
      posts = org.posts.active.of_active_members.from_last_week
      if posts.present?
        OrganizationNotifier.recent_posts(posts).deliver_later
      end
    end
  end
end
