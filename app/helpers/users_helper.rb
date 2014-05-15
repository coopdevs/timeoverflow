module UsersHelper

  def users_as_json
    @users.map do |user|
    {
      id: user.id,
      avatar: avatar_url(user),
      member_id: @memberships[user.id].member_uid,
      username: user.username,
      email: user.email,
      phone: user.phone,
      alt_phone: user.alt_phone,
      balance: @memberships[user.id].account_balance.to_i,

      url: user_path(user),
      edit_link: (superadmin? || admin? || user == current_user)? edit_user_path(user) : "",
      cancel_link: (superadmin? || admin?)? member_path(@memberships[user.id]) : "",
      manage_link: ((superadmin? || admin?) && user != current_user)? toggle_manager_member_path(@memberships[user.id]) : "",
      manager: @memberships[user.id].manager ||= false,
      activate_link: (superadmin? || admin?)? toggle_active_member_path(@memberships[user.id]) : "",
      active: @memberships[user.id].active?
    }
    end.to_json.html_safe
  end

end
