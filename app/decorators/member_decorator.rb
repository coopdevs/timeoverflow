class MemberDecorator < ViewModel
  delegate :user, :member_uid, :active?, to: :object
  delegate :phone, :alt_phone, :username, :description, :last_sign_in_at, to: :user

  def manager?
    !!object.manager
  end

  def row_css_class
    'bg-danger' unless active?
  end

  def inactive_icon
    view.glyph('time') unless active?
  end

  def link_to_self
    view.link_to(user.username, routes.user_path(user))
  end

  def mail_to
    email = user.unconfirmed_email || user.email
    view.mail_to(email) if email && !email.end_with?('example.com')
  end

  def avatar_img(size=32)
    view.image_tag(view.avatar_url(user, size), width: size, height: size)
  end

  def account_balance
    view.seconds_to_hm(object.account.try(:balance) || 0)
  end

  def toggle_manager_member_path
    routes.toggle_manager_member_path(object)
  end

  def cancel_member_path
    routes.member_path(object)
  end

  def toggle_active_member_path
    routes.toggle_active_member_path(object)
  end
end
