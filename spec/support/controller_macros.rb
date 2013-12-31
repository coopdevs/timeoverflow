module ControllerMacros

  def login(user = nil)
    @request.env["devise.mapping"] = Devise.mappings[:user]

    @current_user = (user ? user : Fabricate(:user))
    @current_organization = @current_user.try(:organizations).try(:first)

    sign_in @current_user
  end

end