class SessionsController < ApplicationController

  def create
    _user = User.authenticate_with_persona(params[:assertion])
    if _user['email']
      session[:email] = _user['email']
      if _logged_user = User.find_by_email(_user['email'])
        session[:user_id] = _logged_user.id
      end
      flash.now.alert = "Logged in!"
      head :created
    else
      flash.now.alert = "Invalid email or something"
      head 401
    end
  end

  def destroy
    session[:email] = nil
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end

end

