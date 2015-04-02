class OrganizationNotifierService
  def initialize(organization)
    @organization = organization
  end

  def send_recent_posts_to_online_members
    @organization.each do |org|
      posts = org.posts.actives.from_last_week
      if posts.present?
        OrganizationNotifier.recent_posts(posts).deliver
      end
    end
  end
end
