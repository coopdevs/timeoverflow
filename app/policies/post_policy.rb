class PostPolicy < Struct.new(:user, :post)
  def destroy?
    user == post.user or user.admins?(post.organization)
  end

  def create?
    true
  end

  def update?
    user == post.user or user.admins?(post.organization)
  end

end
