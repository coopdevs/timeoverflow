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

  def set_current?
    user&.as_member_of(organization)
  end
end
