class SessionsController < ApplicationController
  respond_to :json

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      head 200, :notice => "Logged in!"
    else
      flash.now.alert = "Invalid email or password"
      ap user.errors
      respond_with user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    head 200, :notice => "Logged out!"
  end


end
