require 'dry-initializer'

class MemberDecorator
  extend Dry::Initializer

  param :member
  param :view_context

  alias_method :v, :view_context

  delegate :user, :member_uid, :active?, to: :member
  delegate :phone, :alt_phone, :username, to: :user

  def manager?
    !!member.manager
  end

  def row_css_class
    'bg-danger' unless active?
  end

  def inactive_icon
    v.tag(:span, class: %w[glyphicon glyphicon-time]) unless active?
  end

  def link_to_self
    v.link_to(user.username, h.user_path(user))
  end

  def mail_to
    email = user.unconfirmed_email || user.email
    v.mail_to(email) if email && !email.end_with?('example.com')
  end

  def avatar_img
    v.image_tag(v.avatar_url(user, 32), width: 32, height: 32)
  end

  def account_balance
    v.seconds_to_hm(member.account.try(:balance) || 0)
  end

  def edit_user_path
    h.edit_user_path(user)
  end

  def toggle_manager_member_path
    h.toggle_manager_member_path(member)
  end

  def cancel_member_path
    h.member_path(member)
  end

  def toggle_active_member_path
    h.toggle_active_member_path(member)
  end

  private

  def h
    Rails.application.routes.url_helpers
  end
end
