module ControllerMacros

  def login(user = nil)
    user = Fabricate(:user) unless user

    request.session["user_id"] = user.id
    request.session["email"] = user.email
  end

  def current_user
    @current_user ||= User.find(request.session["user_id"]) if request.session["user_id"]
  end

  def current_organization
    @current_organization ||= current_user.try(:organizations).try(:first)
  end

end