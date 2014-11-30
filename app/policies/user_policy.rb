class UserPolicy < ApplicationPolicy
  def new?
    user.admins?(user.organizations.first)
  end

  def create?
    user.admins?(user.organizations.first)
  end

  def update?
    user == record || (
      record.organizations.size == 1 &&
      user.admins?(record.organizations.first)
    )
  end

  class Scope < ApplicationPolicy::Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
