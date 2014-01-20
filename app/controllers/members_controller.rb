class MembersController < ApplicationController
  before_filter :authenticate_user!

  def destroy
    current_organization.members.find(params[:id]).destroy

    redirect_to users_path
  end

  def toggle_manager
    current_organization.members.find(params[:id]).toggle(:manager).save!

    redirect_to :back
  end

end
