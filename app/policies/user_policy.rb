class UserPolicy < ApplicationPolicy
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

  class Scope < ApplicationPolicy::Scope
    attr_reader :member, :user, :organization, :scope

    def initialize(user, scope)
      @member = member
      @user = member.user if member
      @organization = member.organization if member
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
