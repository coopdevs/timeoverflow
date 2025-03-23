class PetitionPolicy < ApplicationPolicy
  alias_method :petition, :record

  def update?
    user.superadmin? || user.admins?(petition.organization)
  end

  def manage?
    user.superadmin? || user.admins?(organization)
  end
end
