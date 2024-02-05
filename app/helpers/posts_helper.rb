module PostsHelper
  def members_for_select(post)
    members = current_organization.members.active.order("members.member_uid").
              map { |mem| ["#{mem.member_uid} #{mem.user.to_s}", mem.user_id] }

    options_for_select(members, selected: post.user.id || current_user.id)
  end
end
