module TransfersHelper
  def accountable_path(accountable)
    if accountable.is_a?(Organization)
      organization_path(accountable)
    else
      user_path(accountable.user)
    end
  end
end
