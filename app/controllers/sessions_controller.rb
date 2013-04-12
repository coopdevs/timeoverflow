class SessionsController < ApplicationController
  respond_to :json

  def create
    user_data = params[:user]
    user = User.find_by_email(user_data[:email]).try do |u|
      u.authenticate(user_data[:password])
    end
    if user
      session[:user_id] = user.id
      redirect_to root_url, notice: "Logged in!"
    else
      # flash.now.alert = "Invalid email or password"
      render :new, status: :unprocessable_entity, alert: "Invalid email or password"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end

  def new
  end

end
