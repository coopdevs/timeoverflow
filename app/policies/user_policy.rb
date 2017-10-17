class UserPolicy < ApplicationPolicy
  def show?
    true
  end

  def new?
    user.admins?(organization)
  end

  def create?
    user.admins?(organization)
  end

  def update?
    user == record || (
      record.organizations.size == 1 &&
      record.organizations.first == organization &&
      user.admins?(organization)
    )
  end
end
