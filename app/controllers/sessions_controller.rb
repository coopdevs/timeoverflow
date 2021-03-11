class SessionsController < Devise::SessionsController
  def create
    super
    flash.delete(:notice)
  end

  def destroy
    super
    flash.delete(:notice)
  end
end
