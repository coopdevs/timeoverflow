class OrganizationNotifierService
  def initialize(organization)
    @organization = organization
  end

  def send_recent_posts_to_online_members
    @organization.each do |org|
      posts = org.posts.where("created_at >= ?", 1.week.ago.beginning_of_day)
      if posts.present?
        OrganizationNotifier.recent_posts(posts).deliver
      end
    end
  end

end
