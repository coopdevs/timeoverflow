class OrganizationPolicy < ApplicationPolicy
  def show?
    user.member(record).present?
  end

  def admin?
    user.admins?(record)
  end
end
