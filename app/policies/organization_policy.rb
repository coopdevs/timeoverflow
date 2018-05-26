class OrganizationPolicy < ApplicationPolicy
  alias_method :organization, :record

  def index?
    true
  end

  def show?
    user&.superadmin? || user&.active?(organization)
  end

  def create?
    user&.superadmin?
  end

  def update?
    user&.superadmin? || user&.admins?(organization)
  end
end
