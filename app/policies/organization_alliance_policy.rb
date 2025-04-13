class OrganizationAlliancePolicy < ApplicationPolicy
  def update?
    alliance = record
    user.manages?(alliance.source_organization) || user.manages?(alliance.target_organization)
  end

  def destroy?
    alliance = record
    user.manages?(alliance.source_organization) || user.manages?(alliance.target_organization)
  end
end
