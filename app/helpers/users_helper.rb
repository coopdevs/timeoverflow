module UsersHelper
  # TODO refactor or eliminate - poosibly the second.
  def users_as_json
    @users = (admin? || superadmin?) ? @users : @users.actives
    @users.map do |user|
      membership = @memberships[user.id]
      {
        id: user.id,
        avatar: avatar_url(user),
        member_id: membership.member_uid,
        username: user.username,
        email: user.email_if_real,
        unconfirmed_email: user.unconfirmed_email,
        phone: user.phone,
        alt_phone: user.alt_phone,
        balance: membership.account_balance.to_i,

        url: user_path(user),
        edit_link: edit_user_path(user),
        cancel_link: cancel_member_path(membership),
        toggle_manager_link: toggle_manager_member_path(membership),
        manager: !!membership.manager,
        toggle_active_link: toggle_active_member_path(membership),
        active: membership.active?,
        valid_email: user.has_valid_email?
      }
    end.to_json.html_safe
  end

  private

  def edit_user_path(user)
    can_edit_user?(user) ? super : ""
  end

  def can_edit_user?(user)
    superadmin? || admin? || user == current_user
  end

  def cancel_member_path(member)
    can_cancel_member?(member) ? member_path(member) : ""
  end

  def can_cancel_member?(_member)
    superadmin? || admin?
  end

  def toggle_manager_member_path(member)
    can_toggle_manager?(member) ? super : ""
  end

  def can_toggle_manager?(member)
    (superadmin? || admin?) && member.user != current_user
  end

  def toggle_active_member_path(member)
    can_toggle_active?(member) ? super : ""
  end

  def can_toggle_active?(_member)
    superadmin? || admin?
  end
end
