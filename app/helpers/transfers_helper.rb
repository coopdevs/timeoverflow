module TransfersHelper
  def accountable_path(accountable)
    if accountable.is_a?(Organization)
      organization_path(accountable)
    else
      user_path(accountable.user)
    end
  end

  def accounts_from_movements(transfer, with_links: false)
    transfer.movements.sort_by(&:amount).map do |movement|
      account = movement.account

      if account.accountable.blank?
        I18n.t('users.show.deleted_user')
      elsif account.accountable_type == 'Organization'
        link_to_if(with_links, account, organization_path(account.accountable))
      elsif account.accountable.active
        link_to_if(with_links, account.accountable.display_name_with_uid, user_path(account.accountable.user))
      else
        I18n.t('users.show.inactive_user')
      end
    end
  end
end
