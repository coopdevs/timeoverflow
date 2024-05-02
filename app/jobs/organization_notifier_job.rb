# A weekly digest email.
#
# Strategy: go throught all organizations and take latest active posts from last week
# posted by active members. Send an email to all confirmed, active and online members
# with the email notifications enabled with those posts. Group emails by user's locale.

# Schedule defined in config/schedule.yml file.

class OrganizationNotifierJob < ActiveJob::Base
  queue_as :cron

  def perform
    Organization.all.find_each do |org|
      posts = org.posts.active.of_active_members.from_last_week

      if posts.present?
        users_by_locale(org).each do |locale, users|
          OrganizationNotifier.recent_posts(posts, locale, users).deliver_now
        end
      end
    end
  end

  private

  def users_by_locale(organization)
    org_users = organization.users.online_active.actives.confirmed.notifications
    org_locales = org_users.pluck(:locale).uniq

    org_locales.each_with_object({}) do |locale, hash|
      hash[locale] = org_users.where(locale: locale)
    end
  end
end
