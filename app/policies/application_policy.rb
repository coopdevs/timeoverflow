class ApplicationPolicy
  attr_reader :member, :user, :organization, :record

  # TODO: Investigate how to just pass current_user here.
  #       Probably this will be solved by scoping the resources
  #       under `/organization`.
  #
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
    record.class.where(id: record.id).exists?
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
end
