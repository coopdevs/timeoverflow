class UserPolicy < ApplicationPolicy
  def show?
    return true if user.id == record.id

    record.organizations.any? do |org|
      user.admins?(org)
    end
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
