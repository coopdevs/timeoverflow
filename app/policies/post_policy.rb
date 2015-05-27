class PostPolicy < ApplicationPolicy
  alias_method :post, :record

  def destroy?
    user == post.user || user.admins?(post.organization)
  end

  def create?
    true
  end

  def update?
    user == post.user || user.admins?(post.organization)
  end
end
