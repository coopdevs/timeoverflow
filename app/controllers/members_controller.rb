class MembersController < ApplicationController
  before_filter :authenticate_user!

  def destroy
    Member.find(params[:id]).destroy

    redirect_to users_path
  end
end
