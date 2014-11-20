module UsersHelper

  def users_as_json
    @users = (admin? || superadmin?)? @users : @users.actives
    @users.map do |user|
      membership = @memberships[user.id]
      {
        id: user.id,
        avatar: avatar_url(user),
        member_id: membership.member_uid,
        username: user.username,
        email: user.email,
        unconfirmed_email: user.unconfirmed_email,
        phone: user.phone,
        alt_phone: user.alt_phone,
        balance: membership.account_balance.to_i,

        url: user_path(user),
        edit_link: (superadmin? || admin? || user == current_user) ? edit_user_path(user) : "",
        cancel_link: (superadmin? || admin?) ? member_path(membership) : "",
        toggle_manager_link: ((superadmin? || admin?) && user != current_user) ? toggle_manager_member_path(membership) : "",
        manager: !!membership.manager,
        toggle_active_link: (superadmin? || admin?) ? toggle_active_member_path(membership) : "",
        active: membership.active?
      }
    end.to_json.html_safe
  end

end
