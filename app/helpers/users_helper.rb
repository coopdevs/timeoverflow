module UsersHelper
  # TODO refactor or eliminate - possibly the second.
  def users_as_json
    @memberships.map do |membership|
      {
        id: membership.user_id,
        avatar: avatar_url(membership.user),
        member_uid: membership.member_uid,
        username: membership.user.username,
        email: membership.user.email_if_real,
        unconfirmed_email: membership.user.unconfirmed_email,
        phone: membership.user.phone,
        alt_phone: membership.user.alt_phone,
        balance: membership.account_balance.to_i,

        url: member_path(membership.member_uid),
        edit_link: edit_user_path(membership.user),
        cancel_link: cancel_member_path(membership),
        toggle_manager_link: toggle_manager_member_path(membership),
        manager: !!membership.manager,
        toggle_active_link: toggle_active_member_path(membership),
        active: membership.active?,
        valid_email: membership.user.has_valid_email?
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
