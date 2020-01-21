class MultiTransferPolicy < ApplicationPolicy
  def step?
    user.admins?(organization)
  end

  def create?
    user.admins?(organization)
  end
end
