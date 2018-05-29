class OrganizationPolicy < ApplicationPolicy
  alias_method :organization, :record

  def index?
    true
  end

  def create?
    user&.superadmin?
  end

  def update?
    user&.superadmin? || user&.admins?(organization)
  end
end
