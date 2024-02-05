module UsersHelper
  def genders_collection
    User::GENDERS.map(&:to_sym)
  end

  def phone_to(phone)
    link_to phone, "tel://#{phone}"
  end

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

  def status_applications(status)
    t('petitions.status_applications', status: t("petitions.status.#{status}").humanize)
  end
end
