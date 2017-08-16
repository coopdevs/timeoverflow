class AccountController < ApplicationController
  # GET /account
  #
  def show
  end

  # GET /account/edit
  #
  def edit
    @user = current_user
  end
end
