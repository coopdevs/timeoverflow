class ApplicationPolicy
  attr_reader :member, :user, :organization, :record

  def initialize(member, record)
    @member = member
    @user = member.user if member
    @organization = member.organization if member
    @record = record
  end

  def index?
    false
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(member, record.class)
  end

  class Scope
    attr_reader :member, :user, :organization, :scope

    def initialize(member, scope)
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
